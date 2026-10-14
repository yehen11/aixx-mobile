/// Single global switch for mock vs real API data across the whole app.
/// Defaults to true (mock data). Override at launch:
///   flutter run --dart-define=USE_TEST_MODE=false
const bool useTestMode =
    bool.fromEnvironment('USE_TEST_MODE', defaultValue: true);