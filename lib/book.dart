library ebisu_asciidoc.book;

import 'dart:convert' as convert;
import 'dart:io';
import 'package:ebisu/ebisu.dart' as ebisu;
import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/appendix.dart';
import 'package:ebisu_asciidoc/bibliography.dart';
import 'package:ebisu_asciidoc/chapter.dart';
import 'package:ebisu_asciidoc/mixins.dart';
import 'package:ebisu_asciidoc/part.dart';
import 'package:ebisu_asciidoc/preface.dart';
import 'package:ebisu_asciidoc/section.dart';
import 'package:id/id.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:quiver/core.dart';
import 'package:quiver/iterables.dart';

export 'package:ebisu_asciidoc/appendix.dart';
export 'package:ebisu_asciidoc/bibliography.dart';
export 'package:ebisu_asciidoc/chapter.dart';
export 'package:ebisu_asciidoc/part.dart';
export 'package:ebisu_asciidoc/preface.dart';
export 'package:ebisu_asciidoc/section.dart';

// custom <additional imports>
// end <additional imports>

final Logger _logger = new Logger('book');

class DocEntityType implements Comparable<DocEntityType> {
  static const DocEntityType APPENDIX = const DocEntityType._(0);

  static const DocEntityType BIBLIOGRAPHY = const DocEntityType._(1);

  static const DocEntityType CHAPTER = const DocEntityType._(2);

  static const DocEntityType PART = const DocEntityType._(3);

  static const DocEntityType PREFACE = const DocEntityType._(4);

  static const DocEntityType SECTION = const DocEntityType._(5);

  static List<DocEntityType> get values => const <DocEntityType>[
        APPENDIX,
        BIBLIOGRAPHY,
        CHAPTER,
        PART,
        PREFACE,
        SECTION
      ];

  final int value;

  int get hashCode => value;

  const DocEntityType._(this.value);

  DocEntityType copy() => this;

  int compareTo(DocEntityType other) => value.compareTo(other.value);

  String toString() {
    switch (this) {
      case APPENDIX:
        return "appendix";
      case BIBLIOGRAPHY:
        return "bibliography";
      case CHAPTER:
        return "chapter";
      case PART:
        return "part";
      case PREFACE:
        return "preface";
      case SECTION:
        return "section";
    }
    return null;
  }

  static DocEntityType fromString(String s) {
    if (s == null) return null;
    switch (s) {
      case "appendix":
        return APPENDIX;
      case "bibliography":
        return BIBLIOGRAPHY;
      case "chapter":
        return CHAPTER;
      case "part":
        return PART;
      case "preface":
        return PREFACE;
      case "section":
        return SECTION;
      default:
        return null;
    }
  }

  String toJson() => toString();

  static DocEntityType fromJson(dynamic v) {
    return (v is String)
        ? fromString(v)
        : (v is int) ? values[v] : v as DocEntityType;
  }
}

/// Convenient access to DocEntityType.APPENDIX with *APPENDIX* see [DocEntityType].
///
const DocEntityType APPENDIX = DocEntityType.APPENDIX;

/// Convenient access to DocEntityType.BIBLIOGRAPHY with *BIBLIOGRAPHY* see [DocEntityType].
///
const DocEntityType BIBLIOGRAPHY = DocEntityType.BIBLIOGRAPHY;

/// Convenient access to DocEntityType.CHAPTER with *CHAPTER* see [DocEntityType].
///
const DocEntityType CHAPTER = DocEntityType.CHAPTER;

/// Convenient access to DocEntityType.PART with *PART* see [DocEntityType].
///
const DocEntityType PART = DocEntityType.PART;

/// Convenient access to DocEntityType.PREFACE with *PREFACE* see [DocEntityType].
///
const DocEntityType PREFACE = DocEntityType.PREFACE;

/// Convenient access to DocEntityType.SECTION with *SECTION* see [DocEntityType].
///
const DocEntityType SECTION = DocEntityType.SECTION;

/// Files are read from [rootPath] and parsed for refactors
class ParsedDocEntity {
  const ParsedDocEntity(
      this.fileName, this.number, this.docEntityType, this.id);

  @override
  bool operator ==(ParsedDocEntity other) =>
      identical(this, other) ||
      fileName == other.fileName &&
          number == other.number &&
          docEntityType == other.docEntityType &&
          id == other.id;

  @override
  int get hashCode => hash4(fileName, number, docEntityType, id);

  /// Basename of file read from disk
  final String fileName;

  /// Dotted number of file
  final String number;

  /// Type of entity encoded in name
  final DocEntityType docEntityType;

  /// Snake case name of [DocEntity]
  final String id;

  // custom <class ParsedDocEntity>
  // end <class ParsedDocEntity>

  toString() => '(${runtimeType}) => ${ebisu.prettyJsonMap(toJson())}';

  Map toJson() => {
        "fileName": ebisu.toJson(fileName),
        "number": ebisu.toJson(number),
        "docEntityType": ebisu.toJson(docEntityType),
        "id": ebisu.toJson(id),
      };

  static ParsedDocEntity fromJson(Object json) {
    if (json == null) return null;
    if (json is String) {
      json = convert.JSON.decode(json);
    }
    assert(json is Map);
    return new ParsedDocEntity._fromJsonMapImpl(json);
  }

  ParsedDocEntity._fromJsonMapImpl(Map jsonMap)
      : fileName = jsonMap["fileName"],
        number = jsonMap["number"],
        docEntityType = DocEntityType.fromJson(jsonMap["docEntityType"]),
        id = jsonMap["id"];
}

class Book extends DocEntity with UsesLevel, HasTitle {
  String rootPath;
  String author;
  Preface preface;
  List<Part> parts = [];
  List<Chapter> chapters = [];
  Bibliography bibliography;
  Appendix appendix;

  /// Mapping of snake case names of DocEntities read from the file system to their number
  Map<String, ParsedDocEntity> readEntities = {};

  // custom <class Book>

  Book(dynamic id, this.rootPath, [String title]) : super(id) {
    this.title = title ?? this.id.title;
  }

  @override
  onChildrenOwnershipEstablished() {
    final Map uniqueIds = new Map();

    /// take opportunity to number all parts
    recursiveNumber(DocEntity entity) {
      if (uniqueIds[entity.id] != null) {
        throw '''
Duplicate DocEntity Id:
   `${entity.fileName}` vs `${uniqueIds[entity.id]}`
You can do better!''';
      }

      uniqueIds[entity.id] = entity.fileName;

      enumerate(entity.children).forEach((IndexedValue iv) {
        DocEntity child = iv.value;
        child.number = entity.number + '.${iv.index + 1}';
        _logger.info('${child.id} -> ${child.fileName}');
        recursiveNumber(child);
      });
    }

    number = id.snake;
    recursiveNumber(this);
  }

  _readCurrentFiles() {
    for (FileSystemEntity file in new Directory(rootPath).listSync()) {
      final fileName = basename(file.path);
      if (fileName.endsWith('asciidoc')) {
        final parsedDocEntity = parseDocEntityFileName(fileName);
        if (parsedDocEntity != null) {
          readEntities[parsedDocEntity.id] = parsedDocEntity;
          _logger.fine('Found $parsedDocEntity');
        } else {
          _logger.severe(
              'Found asciidoc file with unrecognized name format ${fileName}');
        }
      }
    }
  }

  generateBook() {
    _readCurrentFiles();

    recursiveGenerate(DocEntity entity) {
      final parsedDocEntity = parseDocEntityFileName(entity.fileName);
      if (parsedDocEntity != null) {
        assert(parsedDocEntity != null);
        final ParsedDocEntity currentEntity = readEntities[parsedDocEntity.id];
        if (currentEntity != null && currentEntity != parsedDocEntity) {
          final from = join(rootPath, currentEntity.fileName);
          final to = join(rootPath, parsedDocEntity.fileName);
          print('''
Found mis-matched read entity:
---- From model:
$parsedDocEntity
**** From Disk:
$currentEntity
^^^^

Renaming $from to $to
''');
          new File(from).rename(to);
        }
      } else {
        _logger.warning('Bad named asciidoc file ${entity.fileName}');
      }

      final fileName = join(rootPath, entity.fileName);
      mergeWithFile(entity.markup, fileName);
      entity.children.forEach((child) => recursiveGenerate(child));
    }

    recursiveGenerate(this);
  }

  String get markup => br([
        brCompact([
          /// book anchor
          idAnchor,
          '$levelText $title',
          ':Author: ${author ?? "The Common Man"}',
          ':toc:',
          ':doctype: book',
          ':source-highlighter: coderay',
          ':listing-caption: Listing',
          ':numbered:',
        ]),
        codeBlock('top book ${id.snake}'),
        children.map((child) => 'include::${child.fileName}[]'),
        codeBlock('bottom book ${id.snake}'),
      ]);

  @override
  Iterable<DocEntity> get children => concat([
        preface == null ? [] : [preface],
        parts,
        chapters,
        bibliography == null ? [] : [bibliography],
        appendix == null ? [] : [appendix]
      ]);

  // end <class Book>

}

// custom <library book>

Book book(dynamic id, String rootPath, [String title]) =>
    new Book(id, rootPath, title);

ParsedDocEntity parseDocEntityFileName(String fileName) {
  RegExp _asciidocFileRe = new RegExp(r'\w+(\.[\d.]+)?_'
      r'(book|part|chapter|section|appendix|bibliography|preface)_(\w+)\.asciidoc$');

  final match = _asciidocFileRe.firstMatch(fileName);
  if (match != null) {
    return new ParsedDocEntity(fileName, match.group(1),
        DocEntityType.fromString(match.group(2)), match.group(3));
  }

  return null;
}

// end <library book>
