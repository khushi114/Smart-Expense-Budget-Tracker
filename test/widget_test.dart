// Basic smoke test for FinTrackApp widget.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack_expense_tracker/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const FinTrackApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
