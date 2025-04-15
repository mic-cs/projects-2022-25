import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votex/config/firebase_options.dart';
import 'package:votex/config/remote_config_service.dart';
import 'package:votex/screens/enter_otp_screen.dart';
import 'package:votex/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votex/screens/welcome_screen.dart';
import 'package:votex/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Remote Config Service.
  final remoteConfigService = RemoteConfigService();
  await remoteConfigService.initialize();

  // Flag to show welcome screen if this is the first launch.
  final bool isFirstLaunch = await checkFirstLaunch();
  // Flag to check if the onboarding process is complete.
  final bool onboardingComplete = await checkOnboarStatus();

  runApp(VoteXApp(
    onboardingComplete: onboardingComplete,
    isFirstLaunch: isFirstLaunch,
    remoteConfigService: remoteConfigService,
  ));
}

Future<bool> checkOnboarStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  String verificationId = prefs.getString('verificationId') ?? '';
  // if (onboardingComplete) {
  //   await prefs.setBool('onboarding_complete', true);
  // }

  // return onboardingComplete;
  if (verificationId == '') {
    return false;
  }
  return true;
}

Future<bool> checkFirstLaunch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('first_launch', false);
  }

  return isFirstLaunch;
}

class VoteXApp extends StatelessWidget {
  final bool isFirstLaunch;
  final bool onboardingComplete;
  final RemoteConfigService remoteConfigService;

  const VoteXApp({
    super.key,
    required this.isFirstLaunch,
    required this.onboardingComplete,
    required this.remoteConfigService,
  });

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        Provider<RemoteConfigService>.value(value: remoteConfigService),
        Provider<ApiService>.value(value: apiService)
      ],
      child: MaterialApp(
        title: 'VoteX',
        // theme: ThemeData.dark(),
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.greenAccent,
              primary: Colors.green,
              brightness: Brightness.dark,
              surface: Color(0xFF101010)),
        ),
        color: Colors.green,
        home: (!isFirstLaunch && onboardingComplete)
            ? HomeScreen()
            : WelcomeScreen(),
      ),
    );
  }
}
