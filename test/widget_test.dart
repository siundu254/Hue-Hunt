import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hue_hunt/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('home shows Room Raiders and mode cards after onboarding', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': true,
      'locale_code': 'en',
    });
    await tester.pumpWidget(const HueHuntApp());
    // Splash + async provider load (avoid pumpAndSettle — home hero glow repeats forever).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Room Raiders'), findsOneWidget);
    expect(find.text('Spirit Forge — start raid'), findsOneWidget);
    expect(find.textContaining('Classic:'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Friends Hunt'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Friends Hunt'), findsOneWidget);
  });
}
