import 'dart:io';

import 'package:flutter/material.dart';
import 'package:votex/screens/end_screen.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int? _selectedCandidate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "VOTE NOW",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "You can vote for only one candidate.",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w900,
                    fontSize: 14),
              ),
              SizedBox(height: 50),
              Column(
                children: [
                  _buildCandidateButton(1, 'Anandhu J', Colors.redAccent),
                  SizedBox(height: 16),
                  _buildCandidateButton(2, 'Liya', Colors.blueAccent),
                  SizedBox(height: 16),
                  _buildCandidateButton(3, 'NOTA', Colors.white),
                  SizedBox(height: 32),
                  Text(
                    _selectedCandidate == null
                        ? 'Select Candidate'
                        : 'Selected Candidate: Candidate $_selectedCandidate',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedCandidate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select a candidate!'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Proceeding with Candidate $_selectedCandidate',
                            ),
                          ),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EndScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        color: Color(0xFF101010),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateButton(
      int candidateNumber, String candidateName, Color candidateColor) {
    bool isSelected = _selectedCandidate == candidateNumber;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCandidate = candidateNumber;
        });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        backgroundColor: isSelected ? Colors.grey : candidateColor,
        foregroundColor: Colors.black,
      ),
      child: Text(
        candidateName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
