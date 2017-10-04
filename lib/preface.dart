library ebisu_asciidoc.preface;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/mixins.dart';

// custom <additional imports>
// end <additional imports>

class Preface extends DocEntity with HasMarkup {
  // custom <class Preface>

  Preface() : super('preface');

  String get markup => brCompact([
        /// section anchor
        idAnchor,
        '$levelText Preface'
      ]);

  // end <class Preface>

}

// custom <library preface>

Preface preface() => new Preface();

// end <library preface>
