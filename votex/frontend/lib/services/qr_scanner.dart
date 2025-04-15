import 'package:flutter/material.dart';

/// Abstract class for QR scanning functionality.
abstract class QRScanner {
  /// Initiates the QR scanning process using the provided [context].
  /// Returns the scanned data as a [String] or `null` if scanning fails or is cancelled.
  Future<String?> scan(BuildContext context);
}

