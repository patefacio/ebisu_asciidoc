library ebisu_asciidoc.test_section;

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
  final s = section('my_first_section');
  print(s.markup);
  //expect(darkMatter(section.markup), 
});

// end <main>
}
