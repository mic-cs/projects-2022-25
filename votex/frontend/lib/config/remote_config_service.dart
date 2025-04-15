import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setDefaults(<String, dynamic>{
      'api_base_url': 'http://10.0.0.2:8000',
    });
    try {
      await _remoteConfig.fetch();
      await _remoteConfig.activate();
    } catch (e) {
      print('Remote Config fetch failed: $e');
    }
  }

  String get apiBaseUrl => _remoteConfig.getString('api_base_url');
  String get hello => _remoteConfig.getString('hello');
}
