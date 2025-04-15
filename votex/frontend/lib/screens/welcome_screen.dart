import 'package:flutter/material.dart';
import 'package:votex/screens/register_screen.dart';
import 'package:votex/widgets/slide_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _numPages = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: _currentPage == index ? 12.0 : 8.0,
      height: _currentPage == index ? 12.0 : 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Navigate to the HomeScreen.
  void _onSkipOrContinue() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> slides = [
      const SlideWidget(
        title: "Welcome to VoteX",
        subtitle: "where voting counts",
      ),
      const SlideWidget(
        title: "Slide 2",
        subtitle: "Content coming soon...",
      ),
      const SlideWidget(
        title: "Slide 3",
        subtitle: "Content coming soon...",
      ),
      const SlideWidget(
        title: "Slide 4",
        subtitle: "Content coming soon...",
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // The PageView displaying the slides.
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: slides,
          ),
          // Dot indicators at bottom left.
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: List.generate(_numPages, (index) => buildDot(index)),
            ),
          ),
          // Skip/Continue button at bottom right.
          Positioned(
            bottom: 20,
            right: 20,
            child: TextButton(
              onPressed: _onSkipOrContinue,
              child: Text(
                _currentPage == _numPages - 1 ? "Continue" : "Skip",
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
