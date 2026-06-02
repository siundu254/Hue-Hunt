import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hue_hunt/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('home shows Hue Hunt and mode cards after onboarding', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': true,
      'locale_code': 'en',
    });
    await tester.pumpWidget(const HueHuntApp());
    await tester.pumpAndSettle(const Duration(seconds: 4));

    expect(find.text('Hue Hunt'), findsOneWidget);
    expect(find.text('Family Mission'), findsWidgets);
    expect(find.text('Play Family Mission'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Friends Hunt'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Friends Hunt'), findsOneWidget);
  });
}
