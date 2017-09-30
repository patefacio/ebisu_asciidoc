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

  int get level => ancestry.where((e) => e is UsesLevel).length;

  String get levelText => ancestry
      .where((e) => e is UsesLevel)
      .fold(this is UsesLevel ? '=' : '', (elm, prev) => '${elm}=');

  String get idAnchor => '[[${id.snake}]]';

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

abstract class UsesLevel {
  // custom <class UsesLevel>
  // end <class UsesLevel>

}

// custom <library mixins>

makeDocId(dynamic id) => makeId(id is Symbol ? MirrorSystem.getName(id) : id);

// end <library mixins>
