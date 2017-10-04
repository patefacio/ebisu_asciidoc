library ebisu_asciidoc.test_part;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/part.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

// custom <additional imports>
// end <additional imports>

final Logger _logger = new Logger('test_part');

// custom <library test_part>
// end <library test_part>

void main([List<String> args]) {
  if (args?.isEmpty ?? false) {
    Logger.root.onRecord.listen(
        (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
    Logger.root.level = Level.OFF;
  }
// custom <main>

  test('part markup', () {
    final p = part('my_part')
      ..setAsRoot();

    expect(darkMatter(p.markup), darkMatter('''
:numbered!:

<<<
[[my_part]]
= My Part

\'\'\'
:numbered:

// custom <top part my_part>
// end <top part my_part>

// custom <bottom part my_part>
// end <bottom part my_part>
    '''));
  });

// end <main>
}
