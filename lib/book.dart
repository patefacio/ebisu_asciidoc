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
  Preface preface;
  List<Part> parts = [];
  List<Chapter> chapters = [];
  Bibliography bibliography;
  Appendix appendix;

  // custom <class Book>

  Book(dynamic id, [String title]) : super(id) {
    this.title = title ?? this.id.title;
  }

  String get markup => brCompact([
        '[${id.snake}]',
        '$levelText $title',
        codeBlock('top book ${id.snake}'),
        preface?.markup,
        brCompact(parts.map((p) => p.markup)),
        brCompact(chapters.map((c) => c.markup)),
        bibliography?.markup,
        appendix?.markup,
        codeBlock('bottom book ${id.snake}'),
      ]);

  @override
  Iterable<DocEntity> get children => concat([
        preface == null? []:[preface],
        parts,
        chapters,
        bibliography == null? []:[bibliography],
        appendix == null? []: [appendix]
      ]);

  // end <class Book>

}

// custom <library book>

Book book(dynamic id, [String title]) => new Book(id, title);

// end <library book>
