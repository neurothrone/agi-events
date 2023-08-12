import 'dart:async';

String errorMessageFor(Object e) {
  if (e is TimeoutException) {
    return "Check your internet connection and try again.";
  } else {
    return "An unexpected error occurred.";
  }
}
