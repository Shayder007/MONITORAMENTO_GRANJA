// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:app_granja/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App loads dashboard shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AppGranja()));

    // App bar title of dashboard should appear
    expect(find.text('Painel do Motor'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
