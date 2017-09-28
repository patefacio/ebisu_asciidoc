import 'package:logging/logging.dart';
import 'test_part.dart' as test_part;
import 'test_chapter.dart' as test_chapter;
import 'test_bibliography.dart' as test_bibliography;
import 'test_appendix.dart' as test_appendix;
import 'test_preface.dart' as test_preface;

void main() {
  Logger.root.level = Level.OFF;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  test_part.main(null);
  test_chapter.main(null);
  test_bibliography.main(null);
  test_appendix.main(null);
  test_preface.main(null);
}
