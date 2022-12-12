import 'package:logging/logging.dart';

/// Creates logger that can be used in classes used inside a [Builder]
class BuildLoggerFactory  {
  Logger create()=> Logger('build.fallback');
}