library ebisu_asciidoc.book;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/appendix.dart';
import 'package:ebisu_asciidoc/bibliography.dart';
import 'package:ebisu_asciidoc/chapter.dart';
import 'package:ebisu_asciidoc/mixins.dart';
import 'package:ebisu_asciidoc/part.dart';
import 'package:ebisu_asciidoc/preface.dart';
import 'package:ebisu_asciidoc/section.dart';

export 'package:ebisu_asciidoc/appendix.dart';
export 'package:ebisu_asciidoc/bibliography.dart';
export 'package:ebisu_asciidoc/chapter.dart';
export 'package:ebisu_asciidoc/part.dart';
export 'package:ebisu_asciidoc/preface.dart';
export 'package:ebisu_asciidoc/section.dart';

// custom <additional imports>
// end <additional imports>

class Book extends DocEntity with HasTitle {
  Preface preface;
  List<Part> parts = [];
  List<Chapters> chapters = [];
  Bibliography bibliography;
  Appendix appendix;

  // custom <class Book>
  // end <class Book>

}

// custom <library book>
// end <library book>
