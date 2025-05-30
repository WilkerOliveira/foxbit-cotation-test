class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class CouldNotGetInstrumentsException extends AppException {
  CouldNotGetInstrumentsException(super.message);
}

class CouldNotGetQuotesException extends AppException {
  CouldNotGetQuotesException(super.message);
}
