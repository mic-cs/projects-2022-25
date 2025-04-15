import 'id_decoder.dart';

/// Concrete implementation of [IDDecoder] for College IDs.
/// For College IDs, the scanned string is assumed to be the user ID without further processing.
class CollegeIDDecoder implements IDDecoder {
  @override
  String? decode(String scannedData) {
    // For College IDs, simply return the scanned data as the user ID.
    return scannedData;
  }
}
