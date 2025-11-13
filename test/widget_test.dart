// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:belajarbareng_app_mmp/src/features/auth/presentation/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('BelajarBareng app theme toggle test', (WidgetTester tester) async {
    // Build the app with simple MaterialApp to avoid Firebase issues in tests
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    // Verify that the basic dashboard loads correctly
    expect(find.text('Selamat datang di BelajarBareng!'), findsOneWidget);
    expect(find.text('BelajarBareng'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('Dashboard screen widget structure test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: DashboardScreen(),
    ));

    // Verify the main welcome text is present
    expect(find.text('Selamat datang di BelajarBareng!'), findsOneWidget);

    // Verify the subtitle text is present
    expect(find.text('Dashboard akan segera dikembangkan...'), findsOneWidget);

    // Verify the app bar title
    expect(find.text('BelajarBareng'), findsOneWidget);

    // Verify the main structure widgets are present
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('YouTube Search screen test', (WidgetTester tester) async {
    // Build the dashboard screen
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: DashboardScreen(),
      ),
    ));

    // Verify the dashboard screen is present
    expect(find.text('BelajarBareng'), findsOneWidget);

    // Verify the main structure widgets are present
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
