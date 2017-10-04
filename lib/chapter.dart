library ebisu_asciidoc.chapter;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/mixins.dart';
import 'package:ebisu_asciidoc/section.dart';

export 'package:ebisu_asciidoc/section.dart';

// custom <additional imports>
// end <additional imports>

class Chapter extends DocEntity with UsesLevel, HasTitle {
  List<Section> sections = [];

  // custom <class Chapter>

  Chapter(dynamic id, [String title]) : super(id) {
    this.title = title ?? this.id.title;
  }

  String get markup => br([
        brCompact([
          '\n<<<',

          /// chapter anchor
          idAnchor,
          '$levelText $title',
          "\n'''"
        ]),
        codeBlock('top chapter ${id.snake}'),
        children.map((child) => 'include::${child.fileName}[]'),
        codeBlock('bottom chapter ${id.snake}'),
      ]);

  @override
  Iterable<DocEntity> get children => sections;

  // end <class Chapter>

}

// custom <library chapter>

Chapter chapter(dynamic id, [dynamic title]) => new Chapter(id, title);

// end <library chapter>
