import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:votex/screens/face_verification_screen.dart';
import 'package:votex/services/api_service.dart';

class EnterOtpScreen extends StatefulWidget {
  final String verificationId;
  const EnterOtpScreen({super.key, required this.verificationId});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  String phone = '';

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the OTP"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final phoneResponse =
        await apiService.getPhone(verificationId: widget.verificationId);
    if (phoneResponse != 'phone') {
      setState(() {
        phone = phoneResponse;
      });
    }

    // final isValid = await apiService.verifyOtp(
    //   verificationId: widget.verificationId,
    //   otp: otp,
    // );
    final isValid = true;

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Verified Successfully"),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FaceVerificationScreen(
            verificationId: widget.verificationId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP, please try again"),
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    // final apiService = Provider.of<ApiService>(context, listen: false);
    setState(() {
      _isResending = true;
    });

    // final success = await apiService.sendOtp(
    //   verificationId: widget.verificationId,
    // );
    final success = true;
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isResending = false;
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP has been resent")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to resend OTP, please try again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Colors.green),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
        color: Color(0x1008FF10),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please enter the OTP sent to your phone: $phone"),
            const SizedBox(height: 16),
            Center(
              child: Pinput(
                length: 6,
                controller: otpController,
                defaultPinTheme: defaultPinTheme,
                onCompleted: (pin) {
                  _verifyOtp();
                },
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Text("Verify OTP"),
                  ),
            const SizedBox(height: 16),
            _isResending
                ? CircularProgressIndicator()
                : TextButton(
                    onPressed: _resendOtp,
                    child: const Text("Resend OTP"),
                  ),
          ],
        ),
      ),
    );
  }
}
