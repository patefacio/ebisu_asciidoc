library ebisu_asciidoc.bibliography;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/mixins.dart';

// custom <additional imports>
// end <additional imports>

class Bibliography extends DocEntity {
  // custom <class Bibliography>

  Bibliography() : super('bibliography');
  String get markup => brCompact([
    idAnchor,
    codeBlock(id.snake),
    ]);

  // end <class Bibliography>

}

// custom <library bibliography>

Bibliography bibliography() => new Bibliography();

// end <library bibliography>
