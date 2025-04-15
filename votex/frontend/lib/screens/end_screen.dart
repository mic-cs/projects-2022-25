import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:votex/screens/home_screen.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class EndScreen extends StatelessWidget {
  const EndScreen({super.key});

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.celebration,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 24),
              Text(
                'Thank you for voting!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                'Vote verification id: ${generateMd5("$DateTime.now()")}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "You'll receive an email when the results are out.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Rectangular shape
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Home'),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Exit button expands to fill half the width
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Rectangular shape
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Exit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
