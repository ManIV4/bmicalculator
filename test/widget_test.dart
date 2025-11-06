// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Assuming your package name is 'calculatorbmi' based on the import path.
// If not, you might need to adjust this path.
import 'package:calculatorbmi/main.dart';

void main() {
  testWidgets('BMI Calculator loads and displays initial state', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // --- FIX ---
    // The main app widget defined in main.dart is BMICalculatorApp, not MyApp.
    await tester.pumpWidget(const BMICalculatorApp());

    // Verify that our app title is present.
    expect(find.text('BMI Calculator'), findsOneWidget);

    // Verify that it defaults to Metric.
    expect(find.text('Metric'), findsOneWidget);
    expect(find.text('Imperial'), findsOneWidget);
    expect(find.text('Height (cm)'), findsOneWidget);

    // Verify the initial result text is shown.
    expect(find.text('Result will appear here'), findsOneWidget);
  });
}