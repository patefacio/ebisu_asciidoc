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
            ..mixins = ['Entity', 'HasMarkup']
            ..members = [
              member('id')..type = 'Id',
              member('number'),
            ],
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
        ..includesLogger = true
        ..importAndExportAll(libNames.map((i) => myImport(i)))
        ..imports.addAll([
          'package:quiver/iterables.dart',
          'package:path/path.dart',
          'package:id/id.dart',
          'dart:io'
        ])
        ..enums = [
          enum_('doc_entity_type')
            ..values = [
              'appendix',
              'bibliography',
              'chapter',
              'part',
              'preface',
              'section',
            ]
            ..requiresClass = true
            ..isSnakeString = true
            ..hasJsonSupport = true
            ..libraryScopedValuesCase = shoutCase
        ]
        ..classes = [
          class_('parsed_doc_entity')
            ..doc = 'Files are read from [rootPath] and parsed for refactors'
            ..hasOpEquals = true
            ..isImmutable = true
            ..hasJsonToString = true
            ..members = [
              member('file_name')..doc = 'Basename of file read from disk',
              member('number')..doc = 'Dotted number of file',
              member('doc_entity_type')..doc = 'Type of entity encoded in name'..type = 'DocEntityType',
              member('id')..doc = 'Snake case name of [DocEntity]',
            ],
          class_('book')
            ..mixins = ['UsesLevel', 'HasTitle']
            ..extend = 'DocEntity'
            ..members = [
              member('root_path'),
              member('author'),
              member('preface')..type = 'Preface',
              member('parts')
                ..type = 'List<Part>'
                ..init = [],
              member('chapters')
                ..type = 'List<Chapter>'
                ..init = [],
              member('bibliography')..type = 'Bibliography',
              member('appendix')..type = 'Appendix',
              member('read_entities')
                ..doc =
                    'Mapping of snake case names of DocEntities read from the file system to their number'
                ..type = 'Map<String,ParsedDocEntity>'
                ..init = {}
            ]
        ],
      commonLib('part')
        ..importAndExportAll([myImport('chapter')])
        ..classes = [
          class_('part')
            ..extend = 'DocEntity'
            ..mixins = ['UsesLevel', 'HasTitle']
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
            ..mixins = ['UsesLevel', 'HasTitle']
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
            ..mixins = ['UsesLevel', 'HasTitle']
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
            ..mixins = [],
        ],
      commonLib('appendix')
        ..classes = [
          class_('appendix')
            ..extend = 'DocEntity'
            ..mixins = [],
        ],
      commonLib('preface')
        ..classes = [
          class_('preface')
            ..extend = 'DocEntity'
            ..mixins = [],
        ]
    ];

  ebisuAsciidoc.generate(generateDrudge: true);

  print('''
**** NON GENERATED FILES ****
${indentBlock(brCompact(nonGeneratedFiles))}
''');
}
