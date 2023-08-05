import 'package:intl/intl.dart';

extension StringFormat on DateTime {
  /// Formats the [DateTime] into a [String] in the format:
  /// 14:20, 5 Aug
  String get formatted => DateFormat("hh:mm, d MMM").format(this);
}
