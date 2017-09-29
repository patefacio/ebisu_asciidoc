#!/usr/bin/env dart
import 'dart:io';
import 'package:ebisu/ebisu.dart';
import 'package:ebisu/ebisu_dart_meta.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

final _logger = new Logger('ebisuRsDart');

String _topDir;
bool _enableLogging = false;

main(List<String> args) {
  Logger.root.onRecord.listen(
      (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.OFF;
  useDartFormatter = true;
  String here = absolute(Platform.script.toFilePath());
  final purpose = 'Support for generating an asciidoc book';

  _topDir = dirname(dirname(here));
  myImport(i) => 'package:ebisu_asciidoc/${i}.dart';
  commonLib(l) => library(l)
    ..imports.addAll(['package:ebisu/ebisu.dart', myImport('mixins')]);

  final libNames = [
    'part',
    'chapter',
    'section',
    'bibliography',
    'appendix',
    'preface'
  ];

  System ebisuAsciidoc = system('ebisu_asciidoc')
    ..license = 'boost'
    ..pubSpec.homepage = 'https://github.com/patefacio/ebisu_asciidoc'
    ..pubSpec.version = '0.0.0'
    ..pubSpec.doc = purpose
    ..rootPath = _topDir
    ..doc = purpose
    ..scripts = []
    ..testLibraries.addAll(libNames.map((lib) => library('test_${lib}')
      ..imports = [myImport(lib), 'package:ebisu/ebisu.dart']))
    ..libraries = [
      library('mixins')
        ..imports = [
          'dart:mirrors',
          'package:ebisu/ebisu.dart',
          'package:id/id.dart'
        ]
        ..classes = [
          class_('doc_entity')
            ..isAbstract = true
            ..mixins = ['Entity']
            ..members = [member('id')..type = 'Id'],
          class_('has_title')
            ..isAbstract = true
            ..members = [
              member('title'),
            ]
            ..customCodeBlock.tag = null,
          class_('has_anchor')
            ..doc = 'http://asciidoctor.org/docs/user-manual/#anchordef'
            ..isAbstract = true
            ..members = [],
          class_('has_markup')
            ..doc = ''
            ..isAbstract = true
            ..members = [],
          class_('uses_level')..isAbstract = true,
        ],
      commonLib('book')
        ..importAndExportAll(libNames.map((i) => myImport(i)))
        ..imports.addAll(['package:quiver/iterables.dart'])
        ..classes = [
          class_('book')
            ..mixins = ['UsesLevel', 'HasTitle']
            ..extend = 'DocEntity'
            ..members = [
              member('preface')..type = 'Preface',
              member('parts')
                ..type = 'List<Part>'
                ..init = [],
              member('chapters')
                ..type = 'List<Chapter>'
                ..init = [],
              member('bibliography')..type = 'Bibliography',
              member('appendix')..type = 'Appendix',
            ]
        ],
      commonLib('part')
        ..importAndExportAll([myImport('chapter')])
        ..classes = [
          class_('part')
            ..extend = 'DocEntity'
            ..mixins = ['UsesLevel', 'HasTitle', 'HasMarkup']
            ..members = [
              member('chapters')
                ..type = 'List<Chapter>'
                ..init = [],
            ],
        ],
      commonLib('section')
        ..classes = [
          class_('section')
            ..extend = 'DocEntity'
            ..mixins = ['UsesLevel', 'HasTitle', 'HasMarkup']
            ..members = [
              member('sections')
                ..type = 'List<Section>'
                ..init = [],
            ]
        ],
      commonLib('chapter')
        ..importAndExportAll([myImport('section')])
        ..classes = [
          class_('chapter')
            ..extend = 'DocEntity'
            ..mixins = ['UsesLevel', 'HasTitle', 'HasMarkup']
            ..members = [
              member('sections')
                ..type = 'List<Section>'
                ..init = [],
            ]
        ],
      commonLib('bibliography')
        ..classes = [
          class_('bibliography')
            ..extend = 'DocEntity'
            ..mixins = ['HasMarkup'],
        ],
      commonLib('appendix')
        ..classes = [
          class_('appendix')
            ..extend = 'DocEntity'
            ..mixins = ['HasMarkup'],
        ],
      commonLib('preface')
        ..classes = [
          class_('preface')
            ..extend = 'DocEntity'
            ..mixins = ['HasMarkup'],
        ]
    ];

  ebisuAsciidoc.generate(generateDrudge: true);

  print('''
**** NON GENERATED FILES ****
${indentBlock(brCompact(nonGeneratedFiles))}
''');
}
