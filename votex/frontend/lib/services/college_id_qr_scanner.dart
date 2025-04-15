import 'package:flutter/material.dart';
import 'qr_scanner.dart';
import '../screens/qr_scanner_screen.dart';

/// Concrete implementation of [QRScanner] for scanning College IDs.
class CollegeIDQRScanner implements QRScanner {
  @override
  Future<String?> scan(BuildContext context) async {
    // Navigate to the QR scanning page and wait for the result.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerPage()),
    );
    return result as String?;
  }
}
