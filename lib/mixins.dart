library ebisu_asciidoc.mixins;

import 'dart:mirrors';
import 'package:ebisu/ebisu.dart';
import 'package:id/id.dart';

// custom <additional imports>
// end <additional imports>

abstract class DocEntity extends Object with Entity {
  Id id;

  // custom <class DocEntity>

  DocEntity(dynamic id) : this.id = makeDocId(id);

  @override
  Iterable<DocEntity> get children => new Iterable.empty();

  // end <class DocEntity>

}

abstract class HasTitle {
  String title;
}

/// http://asciidoctor.org/docs/user-manual/#anchordef
abstract class HasAnchor {
  // custom <class HasAnchor>

  Id get anchor;

  // end <class HasAnchor>

}

abstract class HasMarkup {
  // custom <class HasMarkup>

  String get markup;

  // end <class HasMarkup>

}

// custom <library mixins>

makeDocId(dynamic id) => makeId(id is Symbol ? MirrorSystem.getName(id) : id);

// end <library mixins>
