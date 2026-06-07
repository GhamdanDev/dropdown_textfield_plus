import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dropdown_textfield_plus_example/main.dart';

void main() {
  testWidgets('HomePage renders all sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage()),
    );

    // AppBar title
    expect(find.text('Form Integration'), findsOneWidget);

    // Section headers
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Submitted Form State'), findsOneWidget);

    // Input labels
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Country'), findsOneWidget);
    expect(find.text('Skills'), findsOneWidget);
    expect(find.text('Framework'), findsOneWidget);

    // Action buttons
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Fill Data'), findsOneWidget);

    // Empty state
    expect(find.text('No data submitted yet'), findsOneWidget);
  });
}
