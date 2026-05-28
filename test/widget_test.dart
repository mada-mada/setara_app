// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:setara_app/main.dart';

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
}
