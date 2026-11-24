import 'package:flutter_test/flutter_test.dart';
import 'package:otterly/main.dart';

void main() {
  testWidgets('Otterly app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const OtterlyApp());
    await tester.pump();

    expect(find.byType(OtterlyApp), findsOneWidget);
  });
}