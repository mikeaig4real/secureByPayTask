import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('App smoke test initializes SecureByPayApp', (WidgetTester tester) async {
    await tester.pumpWidget(const SecureByPayApp());
    await tester.pump();
    expect(find.byType(SecureByPayApp), findsOneWidget);
  });
}
