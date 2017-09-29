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
  commonLib(l) => library(l)..imports.add(myImport('mixins'));
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
    ..testLibraries.addAll(libNames.map((lib) => library('test_${lib}')))
    ..libraries = [
      library('mixins')
        ..classes = [
          class_('has_title')
            ..isAbstract = true
            ..members = [
              member('title'),
            ]
        ],
      library('book')
        ..importAndExportAll(libNames.map((i) => myImport(i)))
        ..classes = [
          class_('book'),
        ],
      library('part')
        ..classes = [
          class_('part')
            ..members = [
              member('chapters')
                ..type = 'List<Chapter>'
                ..init = [],
            ],
        ],
      library('section')
        ..classes = [
          class_('section'),
        ],
      library('chapter')
        ..classes = [
          class_('chapter')
            ..members = [
              member('sections')
                ..type = 'List<Section>'
                ..init = [],
            ]
        ],
      library('bibliography')
        ..classes = [
          class_('bibliography'),
        ],
      library('appendix')
        ..classes = [
          class_('appendix'),
        ],
      library('preface')
        ..classes = [
          class_('appendix'),
        ]
    ];

  ebisuAsciidoc.generate(generateDrudge: true);

  print('''
**** NON GENERATED FILES ****
${indentBlock(brCompact(nonGeneratedFiles))}
''');
}
