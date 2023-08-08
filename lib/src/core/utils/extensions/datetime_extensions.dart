import 'package:intl/intl.dart';

extension StringFormat on DateTime {
  /// Formats the [DateTime] into a [String] in the format:
  /// 14:20, 05 Aug
  String get formatted => DateFormat("hh:mm, dd MMM").format(this);

  /// Formats the [DateTime] into a [String] in the format:
  /// 14:20 Sat 5 Aug 2023
  String get formattedForExport => DateFormat("HH:mm E d MMM y").format(this);
}
