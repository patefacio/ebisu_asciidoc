library ebisu_asciidoc.appendix;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/mixins.dart';

// custom <additional imports>
// end <additional imports>

class Appendix extends DocEntity {
  // custom <class Appendix>

  Appendix() : super('appendix');
  String get markup => brCompact([
        idAnchor,
        codeBlock(id.snake),
      ]);

  // end <class Appendix>

}

// custom <library appendix>

Appendix appendix() => new Appendix();

// end <library appendix>
