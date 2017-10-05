library ebisu_asciidoc.test_appendix;

import 'package:ebisu/ebisu.dart';
import 'package:ebisu_asciidoc/appendix.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

// custom <additional imports>

import 'package:ebisu_asciidoc/book.dart';

// end <additional imports>

final Logger _logger = new Logger('test_appendix');

// custom <library test_appendix>
// end <library test_appendix>

void main([List<String> args]) {
  if (args?.isEmpty ?? false) {
    Logger.root.onRecord.listen(
        (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
    Logger.root.level = Level.OFF;
  }
// custom <main>

  test('appendix markup', () {
    final a = appendix()..setAsRoot();

    expect(darkMatter(a.markup), darkMatter('''
[[appendix]]
// custom <appendix>
// end <appendix>
    '''));
  });

// end <main>
}
