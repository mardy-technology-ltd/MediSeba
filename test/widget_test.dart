import 'package:flutter_test/flutter_test.dart';
import 'package:mediseba/app.dart';

void main() {
  testWidgets('MediSeba smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediSebaApp());
    expect(find.text('মেডিস সেবা'), findsOneWidget);
  });
}
