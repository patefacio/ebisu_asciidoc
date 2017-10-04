library ebisu_asciidoc.section;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/mixins.dart';

// custom <additional imports>
// end <additional imports>

class Section extends DocEntity with UsesLevel, HasTitle {
  List<Section> sections = [];

  // custom <class Section>

  Section(dynamic id, [String title]) : super(id) {
    this.title = title ?? this.id.title;
  }

  String get markup => br([
        brCompact([
          /// section anchor
          idAnchor,
          '$levelText $title'
        ]),
        codeBlock('top section ${id.snake}'),
        children.map((child) => 'include::${child.fileName}[]'),
        codeBlock('bottom section ${id.snake}'),
      ]);

  @override
  Iterable<DocEntity> get children => sections;

  // end <class Section>

}

// custom <library section>

Section section(dynamic id, [String title]) => new Section(id, title);

// end <library section>
