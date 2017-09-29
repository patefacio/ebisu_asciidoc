library ebisu_asciidoc.section;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/mixins.dart';

// custom <additional imports>
// end <additional imports>

class Section extends DocEntity with UsesLevel, HasTitle, HasMarkup {
  List<Section> sections = [];

  // custom <class Section>

  Section(dynamic id, [String title]) : super(id) {
    this.title = title ?? this.id.title;
  }

  String get markup => brCompact([
        '[${id.snake}]',
        '$levelText $title',
        codeBlock('top section ${id.snake}'),
        brCompact(sections.map((s) => s.markup)),
        codeBlock('bottom section ${id.snake}'),
      ]);

  @override
  Iterable<DocEntity> get children => sections;

  // end <class Section>

}

// custom <library section>

Section section(dynamic id, [String title]) => new Section(id, title);

// end <library section>
