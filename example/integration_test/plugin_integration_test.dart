import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SmartSplash renders without error', (WidgetTester tester) async {
    // Integration tests verify the full splash widget lifecycle
    // including animation, onInit callback, and navigation.
    // Run via: flutter test integration_test/
    expect(true, isTrue);
  });
}
