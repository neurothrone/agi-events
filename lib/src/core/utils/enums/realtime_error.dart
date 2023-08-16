enum RealtimeError {
  noInternetConnection,
  unknown,
}

extension Message on RealtimeError {
  String get message => switch (this) {
        RealtimeError.noInternetConnection =>
          "Check your internet connection and try again.",
        RealtimeError.unknown => "An unexpected error occurred",
      };
}
