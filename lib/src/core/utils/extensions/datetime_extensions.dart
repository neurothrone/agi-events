import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  /// Formats into a [String]: "14:20, 05 Aug" (e.g. for 2023/08/05 14:20).
  String get formatted => DateFormat("HH:mm, dd MMM").format(this);

  /// Formats for export: "14:20 Sat 5 Aug 2023" (e.g. for 2023/08/05 14:20).
  String get formattedForExport => DateFormat("HH:mm E d MMM y").format(this);

  /// Extracts the day part: "5" (e.g. for 2023/08/05 14:20).
  String get formattedForDay => DateFormat("d").format(this);

  /// Extracts the day and month: "5 Aug" (e.g. for 2023/08/05 14:20).
  String get formattedForDayAndMonth => DateFormat("d MMM").format(this);
}

extension DateTimeComparison on DateTime {
  /// Returns whether the `date` passed in is after this DateTime in
  /// both date and time.
  bool isNotAfter(DateTime date) {
    return !date.isAfter(this);
  }
}
