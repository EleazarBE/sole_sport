import 'package:flutter_test/flutter_test.dart';
import 'package:sole_sport/main.dart';

void main() {
  testWidgets('SOLE//SPORT storefront loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SoleSportApp());

    expect(find.text('SOLE//SPORT'), findsOneWidget);
    expect(find.text('Popular Sneakers'), findsOneWidget);
    expect(find.text('FIND YOUR\nNEXT STEP.'), findsOneWidget);
  });
}
