library ebisu_asciidoc.test_chapter;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/chapter.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

// custom <additional imports>
// end <additional imports>

final Logger _logger = new Logger('test_chapter');

// custom <library test_chapter>
// end <library test_chapter>

void main([List<String> args]) {
  if (args?.isEmpty ?? false) {
    Logger.root.onRecord.listen(
        (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
    Logger.root.level = Level.OFF;
  }
// custom <main>

  test('chapter markup', () {
    final c = chapter('my_first_chapter')
      ..sections = [
        section('next_section')..sections = [section('another_section')]
      ]
      ..setAsRoot();

    expect(darkMatter(c.markup), darkMatter('''

<<<
[[my_first_chapter]]
= My First Chapter

\'\'\'

// custom <top chapter my_first_chapter>
// end <top chapter my_first_chapter>

include::null_section_next_section.asciidoc[]

// custom <bottom chapter my_first_chapter>
// end <bottom chapter my_first_chapter>
    '''));
  });

// end <main>
}
