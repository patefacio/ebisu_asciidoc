library ebisu_asciidoc.section;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/mixins.dart';

// custom <additional imports>
// end <additional imports>

class Section extends DocEntity with HasTitle, HasMarkup {
  // custom <class Section>

  Section(dynamic id, [String title]) : super(id) {
    this.title = title ?? this.id.title;
  }

  String get markup => brCompact([
        '[${id.snake}]',
        '=== $title',
      ]);

  // end <class Section>

}

// custom <library section>

Section section(dynamic id, [String title]) => new Section(id, title);

// end <library section>
