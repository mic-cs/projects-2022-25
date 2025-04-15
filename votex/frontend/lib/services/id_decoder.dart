/// Abstract class for decoding a scanned string into a user ID.
abstract class IDDecoder {
  /// Given the raw scanned data, derive and return the user ID.
  /// Returns `null` if the data is invalid or cannot be decoded.
  String? decode(String scannedData);
}

