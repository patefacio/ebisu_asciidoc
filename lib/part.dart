library ebisu_asciidoc.part;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/chapter.dart';
import 'package:ebisu_asciidoc/mixins.dart';

export 'package:ebisu_asciidoc/chapter.dart';

// custom <additional imports>
// end <additional imports>

class Part extends DocEntity with UsesLevel, HasTitle {
  List<Chapter> chapters = [];

  // custom <class Part>

  Part(dynamic id, [String title]) : super(id) {
    this.title = title ?? this.id.title;
  }

  String get markup => br([
        brCompact([
          ':numbered!:',

          /// part anchor
          '\n<<<',
          idAnchor,
          '$levelText $title',
          "\n'''",
          ':numbered:',
        ]),
        codeBlock('top part ${id.snake}'),
        children.map((child) => 'include::${child.fileName}[]'),
        codeBlock('bottom part ${id.snake}'),
      ]);

  @override
  Iterable<DocEntity> get children => chapters;

  // end <class Part>

}

// custom <library part>

Part part(dynamic id, [String title]) => new Part(id, title);

// end <library part>
