import 'package:intl/intl.dart';

extension StringFormat on DateTime {
  /// Formats the [DateTime] into a [String] in the format:
  /// 2023/08/05 14:20 => 14:20, 05 Aug
  String get formatted => DateFormat("HH:mm, dd MMM").format(this);

  /// Formats the [DateTime] into a [String] in the format:
  /// 14:20 Sat 5 Aug 2023
  /// 2023/08/05 14:20 => 14:20 Sat 5 Aug 2023
  String get formattedForExport => DateFormat("HH:mm E d MMM y").format(this);

  /// Formats the [DateTime] into a [String] in the format:
  /// 2023/08/05 14:20 => 5
  String get formattedForDay => DateFormat("d").format(this);

  /// Formats the [DateTime] into a [String] in the format:
  /// 2023/08/05 14:20 => 5 Aug
  String get formattedForDayAndMonth => DateFormat("d MMM").format(this);
}

extension DateTimeUtils on DateTime {
  /// Returns whether the `date` passed in is after this [DateTime]
  /// in both date and time
  bool isNotAfter(DateTime date) {
    return !date.isAfter(this);
  }
}
