import 'package:flutter/foundation.dart';

class EnvConfig {
  // Use http://10.0.2.2:5000/api for Android Emulator
  // Use http://localhost:5000/api for Web/iOS Simulator
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: kIsWeb ? 'http://localhost:5000/api' : 'http://10.0.2.2:5000/api',
  );
}
