import '../../../core/models/models.dart';
import '../../../core/utils/utils.dart';

extension ListLeadCsvExtensions on List<Lead> {
  List<List<String>> toCsvDataRows() {
    List<List<String>> dataRows = map(
      (lead) => lead.toCsvRow(),
    ).toList();

    // Add headers to the beginning of the list
    dataRows.insert(0, LeadCsvExtensions.csvHeaders());

    return dataRows;
  }
}

extension LeadCsvExtensions on Lead {
  List<String> toCsvRow() => [
        email,
        firstName,
        lastName,
        company,
        position ?? "",
        phone ?? "",
        address ?? "",
        zipCode ?? "",
        city ?? "",
        notes ?? "",
        scannedAt.formattedForExport,
      ];

  static List<String> csvHeaders() => [
        "E-mail",
        "First Name",
        "Last Name",
        "Company",
        "Position",
        "Phone Number",
        "Address",
        "Zip Code",
        "City",
        "Notes",
        "Scanned at time",
      ];
}
