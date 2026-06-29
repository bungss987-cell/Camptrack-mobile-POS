/// Centralized configuration for the CampTrack app.
/// Change [environment] to switch between dev/staging/production.
class AppConfig {
  // Change this to switch environments
  static const Environment environment = Environment.development;

  static String get baseUrl {
    switch (environment) {
      case Environment.development:
        // Use 10.0.2.2 for Android emulator (maps to host localhost)
        // Use localhost for iOS simulator
        // Use your machine IP for physical devices
        return 'http://10.0.2.2:3000/api';
      case Environment.staging:
        return 'https://staging-api.camptrack.id/api';
      case Environment.production:
        return 'https://api.camptrack.id/api';
    }
  }

  static String get wsUrl {
    switch (environment) {
      case Environment.development:
        return 'ws://10.0.2.2:3001';
      case Environment.staging:
        return 'wss://staging-ws.camptrack.id';
      case Environment.production:
        return 'wss://ws.camptrack.id';
    }
  }

  static String get appName => 'CampTrack';
  static String get appVersion => '1.0.0';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

enum Environment {
  development,
  staging,
  production,
}
