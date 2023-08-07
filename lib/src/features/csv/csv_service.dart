import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final csvServiceProvider = Provider<CsvService>((ref) {
  return CsvService();
});

class CsvService {
  final _converter = const ListToCsvConverter();

  Future<File> exportToCSV({
    required List<List<String>> rows,
    required String fileName,
  }) async {
    String csvString = _converter.convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = "${directory.path}/$fileName.csv";
    File file = await File(pathOfTheFileToWrite).create(recursive: true);
    await file.writeAsString(csvString);

    return file;
  }
}
