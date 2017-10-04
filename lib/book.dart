library ebisu_asciidoc.book;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/appendix.dart';
import 'package:ebisu_asciidoc/bibliography.dart';
import 'package:ebisu_asciidoc/chapter.dart';
import 'package:ebisu_asciidoc/mixins.dart';
import 'package:ebisu_asciidoc/part.dart';
import 'package:ebisu_asciidoc/preface.dart';
import 'package:ebisu_asciidoc/section.dart';
import 'package:quiver/iterables.dart';

export 'package:ebisu_asciidoc/appendix.dart';
export 'package:ebisu_asciidoc/bibliography.dart';
export 'package:ebisu_asciidoc/chapter.dart';
export 'package:ebisu_asciidoc/part.dart';
export 'package:ebisu_asciidoc/preface.dart';
export 'package:ebisu_asciidoc/section.dart';

// custom <additional imports>
// end <additional imports>

class Book extends DocEntity with UsesLevel, HasTitle {
  String rootPath;
  String author;
  Preface preface;
  List<Part> parts = [];
  List<Chapter> chapters = [];
  Bibliography bibliography;
  Appendix appendix;

  // custom <class Book>

  Book(dynamic id, this.rootPath, [String title]) : super(id) {
    this.title = title ?? this.id.title;
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
        preface?.markup,
        br(parts.map((p) => p.markup)),
        br(chapters.map((c) => c.markup)),
        bibliography?.markup,
        appendix?.markup,
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

// end <library book>
