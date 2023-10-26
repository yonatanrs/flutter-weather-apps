// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart'; // Sesuaikan dengan lokasi file main.dart Anda

void main() {
  testWidgets('Example widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp()); // Hapus kata kunci `const`

    // Verify that text "Hello, World!" is present in the widget tree.
    expect(find.text('Hello, World!'), findsOneWidget);

    // Anda dapat menambahkan lebih banyak kasus uji di sini sesuai dengan widget Anda.
  });
}
