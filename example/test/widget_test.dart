import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart'; 

void main() {
  testWidgets('SimpleSheetsDemo smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: SimpleSheetsDemo()));

    // Verify that the title is present
    expect(find.text('SimpleSheets Demo'), findsOneWidget);
    
    // Verify inputs exist
    expect(find.byType(TextField), findsNWidgets(2)); // Creds + ID
  });
}
