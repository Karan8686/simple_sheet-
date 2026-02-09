import 'package:flutter_test/flutter_test.dart';
import 'package:simple_sheets/simple_sheets.dart';

void main() {
  test('SimpleSheets instantiation', () {
    final sheet = SimpleSheets(
      credentials: '{"test": "data"}',
      spreadsheetId: '12345',
    );
    expect(sheet, isNotNull);
  });
}
