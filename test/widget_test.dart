import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otterly/main.dart';

void main() {
  testWidgets('Otterly app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OtterlyApp());
    await tester.pump();

    expect(find.byType(OtterlyApp), findsOneWidget);

    // Advance past the 3-second splash timer before test teardown.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}