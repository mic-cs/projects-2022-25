import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votex/screens/voting_screen.dart';
import 'package:votex/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? verificationId;
  String? photo;
  String? name;
  String? dob;
  String? phone;

  Future<void> _handleUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      verificationId = prefs.getString('verificationId');
    });
    if (!mounted) return;
    final apiService = Provider.of<ApiService>(context, listen: false);
    if (verificationId != null) {
      final user = await apiService.getUser(verificationId: verificationId!);
      setState(() {
        photo = user['photo'];
        name = user['name'];
        dob = user['dob'];
        phone = user['phone'];
        phone =
            phone!.substring(0, 6) + List.filled(phone!.length - 6, "*").join();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _handleUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile."),
        titleTextStyle: TextStyle(
          color: Colors.green,
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(photo ??
                        'https://res.cloudinary.com/demazndgq/image/upload/v1741851165/n0pgcapuvvmpapamjjd6.jpg'),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? 'Hari Sankar R S',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'DOB:      ${dob ?? "14/06/2005"}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Phone:   ${phone ?? "+91******908599"}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 22),
              Text(
                'Eligible to vote for the following elections:',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.green,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(color: Colors.green),
                child: ListTile(
                  title: Text(
                    'Class elections 2025',
                    style: TextStyle(
                      color: Color(0xFF101010),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VotingScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Vote",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
