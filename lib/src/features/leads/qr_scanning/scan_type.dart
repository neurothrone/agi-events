enum ScanType {
  exhibitor,
  visitor;

  String get title => switch (this) {
        exhibitor => "Scan your exhibitor badge",
        visitor => "Scan a visitor badge",
      };
}
