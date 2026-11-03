import 'package:flutter_test/flutter_test.dart';
import 'package:culina/main.dart';

void main() {
  testWidgets('Culina splash screen renders branding', (WidgetTester tester) async {
    await tester.pumpWidget(const CulinaApp());

    // Verify splash screen elements
    expect(find.text('Culina'), findsOneWidget);
    expect(find.text('Cocina artesanal paso a paso en tu móvil'), findsOneWidget);

    // Fast-forward past the splash timer (1800ms)
    await tester.pump(const Duration(milliseconds: 2500));
  });
}
