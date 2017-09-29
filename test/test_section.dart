library ebisu_asciidoc.test_section;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/section.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

// custom <additional imports>
// end <additional imports>

final Logger _logger = new Logger('test_section');

// custom <library test_section>
// end <library test_section>

void main([List<String> args]) {
  if (args?.isEmpty ?? false) {
    Logger.root.onRecord.listen(
        (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
    Logger.root.level = Level.OFF;
  }
// custom <main>

  test('section markup', () {
    final s = section('my_first_section')
      ..sections = [
        section('next_section')..sections = [section('another_section')]
      ]
      ..setAsRoot();

    expect(darkMatter(s.markup), darkMatter('''
[my_first_section]
= My First Section
// custom <top section my_first_section>
// end <top section my_first_section>
[next_section]
== Next Section
// custom <top section next_section>
// end <top section next_section>
[another_section]
=== Another Section
// custom <top section another_section>
// end <top section another_section>
// custom <bottom section another_section>
// end <bottom section another_section>
// custom <bottom section next_section>
// end <bottom section next_section>
// custom <bottom section my_first_section>
// end <bottom section my_first_section>
   '''));
  });

// end <main>
}
