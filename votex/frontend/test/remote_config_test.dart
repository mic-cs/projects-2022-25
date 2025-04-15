import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:http/http.dart' as http;
import 'package:votex/config/firebase_options.dart';
import 'package:votex/config/remote_config_service.dart';

void main() {
  // Ensure that widget binding is initialized.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Firebase Remote Config Integration', () {
    test('RemoteConfig parameter "hello" returns "world"', () async {
      // Initialize Firebase with your configuration.
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // For testing, set a low minimum fetch interval so that we force a new fetch.
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      
      // Fetch and activate the remote config.
      await remoteConfig.fetchAndActivate();
      
      // Retrieve the value of the key "hello".
      final helloValue = remoteConfig.getString('hello');
      print('RemoteConfig "hello" value: $helloValue');
      expect(helloValue, equals('world'));
    });

    test('RemoteConfigService retrieves "hello" key as "world"', () async {
      // Initialize Firebase.
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Create an instance of your RemoteConfigService.
      final remoteConfigService = RemoteConfigService();
      await remoteConfigService.initialize();

      // Assuming you add a generic getter in RemoteConfigService.
      final helloValue = remoteConfigService.hello;
      print('RemoteConfigService "hello" value: $helloValue');
      expect(helloValue, equals('world'));
    });
  });

  group('FastAPI /hello-world Endpoint Integration', () {
    test('GET /hello-world returns "hello world"', () async {
      // Initialize Firebase to get the API URL from Remote Config.
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Initialize your RemoteConfigService.
      final remoteConfigService = RemoteConfigService();
      await remoteConfigService.initialize();
      
      // Retrieve the API base URL from remote config.
      final apiUrl = remoteConfigService.apiBaseUrl;
      print('Using API base URL: $apiUrl');
      
      // Construct the full URL for the /hello-world endpoint.
      final url = Uri.parse('$apiUrl/hello-world');

      // Send a GET request to the /hello-world endpoint.
      final response = await http.get(url);
      print('API response status: ${response.statusCode}, body: ${response.body}');
      
      // Validate that the API returned "hello world".
      expect(response.statusCode, equals(200));
      expect(response.body, equals('hello world'));
    });
  });
}

