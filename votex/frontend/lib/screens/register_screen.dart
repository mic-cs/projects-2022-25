import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votex/screens/enter_otp_screen.dart';
import 'package:votex/services/api_service.dart';
import 'package:votex/services/college_id_decoder.dart';
import 'package:votex/services/college_id_qr_scanner.dart';
import 'package:votex/services/id_decoder.dart';
import 'package:votex/services/qr_scanner.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> idTypes = ['College ID', 'Aadhaar', 'Voter ID'];
  String? selectedIdType = 'College ID';
  String? derivedUserId;

  Future<void> _handleQRScan() async {
    // final apiService = Provider.of<ApiService>(context, listen: false);
    if (selectedIdType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Plese select and ID type before scanning."),
        ),
      );
      return;
    }

    QRScanner scanner = CollegeIDQRScanner();
    String? scannedRawData = await scanner.scan(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    if (scannedRawData != null) {
      late IDDecoder decoder;
      if (selectedIdType == 'College ID') {
        decoder = CollegeIDDecoder();
      } else {
        // Default fallback if needed.
        decoder = CollegeIDDecoder();
      }

      String? userId = decoder.decode(scannedRawData);

      if (userId != null) {
        setState(() {
          derivedUserId = userId;
        });
        prefs.setString('verificationId', userId);

        // bool otpSent = await apiService.sendOtp(verificationId: userId);
        bool otpSent = true;
        sleep(Duration(seconds: 1));

        if (!mounted) return;

        if (otpSent) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnterOtpScreen(
                verificationId: userId,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to send OTP. Please try again"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to decode the scannd QR data."),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("QR scan was cancelled or faild."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2021),
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedIdType,
              decoration: const InputDecoration(
                labelText: "Select ID Type",
                border: OutlineInputBorder(),
              ),
              items: idTypes
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedIdType = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleQRScan,
              child: const Text("Scan QR code / Barcode"),
            ),
            const SizedBox(height: 20),
            if (derivedUserId != null)
              Text(
                "Derived User ID: $derivedUserId",
                style: const TextStyle(fontSize: 16),
              )
          ],
        ),
      ),
    );
  }
}
