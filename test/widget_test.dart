import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safesteps/main.dart';

void main() {
  testWidgets('SafeSteps app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const SafeStepsApp(showOnboarding: false),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
