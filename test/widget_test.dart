// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:setara_app/main.dart';
import 'package:setara_app/features/superadmin/screens/super_admin_central.dart';

void main() {
  testWidgets('App rendering and navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Main());

    // Verify that the login page is rendered.
    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);

    // Scroll 'Daftar' into view and tap on it to go to SignUpPage
    final daftarFinder = find.text('Daftar');
    await tester.ensureVisible(daftarFinder);
    await tester.tap(daftarFinder);
    await tester.pumpAndSettle();

    // Verify that the Sign Up page is rendered.
    expect(find.text('Buat Akun Baru'), findsOneWidget);
  });

  testWidgets('Forgot password navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Main());

    // Verify that the login page is rendered.
    expect(find.text('Selamat Datang'), findsOneWidget);

    // Scroll 'Lupa Sandi?' into view and tap on it
    final lupaSandiFinder = find.text('Lupa Sandi?');
    await tester.ensureVisible(lupaSandiFinder);
    await tester.tap(lupaSandiFinder);
    await tester.pumpAndSettle();

    // Verify that Forgot Password page is rendered
    expect(find.text('Lupa Kata Sandi?'), findsOneWidget);
    expect(find.text('Email Terdaftar'), findsOneWidget);
  });

  testWidgets('Super Admin Central rendering, tabs and search test', (WidgetTester tester) async {
    // Build SuperAdminCentralPage in MaterialApp
    await tester.pumpWidget(
      const MaterialApp(
        home: SuperAdminCentralPage(),
      ),
    );

    // Verify initial rendering elements
    expect(find.text('SetaraApp'), findsOneWidget);
    expect(find.text('System Control'), findsOneWidget);
    expect(find.text('Total Admins'), findsOneWidget);

    // Verify admins in the list
    expect(find.text('Alex Rivera'), findsOneWidget);
    expect(find.text('Jordan Chen'), findsOneWidget);
    expect(find.text('Elena Moretti'), findsOneWidget);

    // Scroll text field into view
    await tester.ensureVisible(find.byType(TextField));
    await tester.pumpAndSettle();

    // Perform Search for "Jordan"
    await tester.enterText(find.byType(TextField), 'Jordan');
    await tester.pump();

    // Verify only Jordan is visible
    expect(find.text('Jordan Chen'), findsOneWidget);
    expect(find.text('Alex Rivera'), findsNothing);
    expect(find.text('Elena Moretti'), findsNothing);

    // Clear Search query
    final closeButtonFinder = find.byIcon(Icons.close_rounded);
    await tester.ensureVisible(closeButtonFinder);
    await tester.tap(closeButtonFinder);
    await tester.pumpAndSettle();

    // Verify all return
    expect(find.text('Alex Rivera'), findsOneWidget);
    expect(find.text('Jordan Chen'), findsOneWidget);
    expect(find.text('Elena Moretti'), findsOneWidget);

    // Switch to Analytics Tab
    await tester.tap(find.byIcon(Icons.analytics_outlined).last);
    await tester.pumpAndSettle();

    // Verify Analytics elements
    expect(find.text('System Analytics'), findsOneWidget);
    expect(find.text('Peak Ordering Hours'), findsOneWidget);

    // Switch to Settings Tab
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // Verify Settings elements
    expect(find.text('System Settings'), findsOneWidget);
    expect(find.text('High Contrast Theme'), findsOneWidget);

    // Switch to Help Tab
    await tester.tap(find.byIcon(Icons.help_outline_rounded));
    await tester.pumpAndSettle();

    // Verify Help elements
    expect(find.text('Help & Manuals'), findsOneWidget);
    expect(find.text('Pengenalan Portal Symmetrical'), findsOneWidget);
  });
}
