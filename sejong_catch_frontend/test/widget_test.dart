import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sejong_catch_frontend/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SejongCatchApp());

    // Wait for any async operations to complete
    await tester.pumpAndSettle();

    // Verify that the app launches successfully
    // The exact text depends on what's actually shown - this is just a basic smoke test
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App has Material components', (WidgetTester tester) async {
    await tester.pumpWidget(const SejongCatchApp());

    // Wait for routing to complete
    await tester.pumpAndSettle();

    // Verify that core Material components exist
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    expect(find.byType(AppBar), findsOneWidget);
  });
}