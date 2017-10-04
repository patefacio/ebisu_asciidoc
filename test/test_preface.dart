library ebisu_asciidoc.test_preface;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/preface.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

// custom <additional imports>

import 'package:ebisu_asciidoc/book.dart';

// end <additional imports>

final Logger _logger = new Logger('test_preface');

// custom <library test_preface>
// end <library test_preface>

void main([List<String> args]) {
  if (args?.isEmpty ?? false) {
    Logger.root.onRecord.listen(
        (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
    Logger.root.level = Level.OFF;
  }
// custom <main>

  test('preface markup', () {
    final p = preface()
      ..setAsRoot();

    expect(darkMatter(p.markup), darkMatter('''
[[preface]]
// custom <preface>
// end <preface>
    '''));
  });

// end <main>
}
