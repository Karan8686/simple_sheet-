library simple_sheets;

import 'package:gsheets/gsheets.dart';

/// A wrapper to make Google Sheets easy.
class SimpleSheets {
  final GSheets _gsheets;
  late final Spreadsheet _spreadsheet;
  final String _spreadsheetId;
  
  /// Initialize with your Google Cloud Credentials JSON and Spreadsheet ID.
  SimpleSheets({required String credentials, required String spreadsheetId})
      : _gsheets = GSheets(credentials),
        _spreadsheetId = spreadsheetId;

  /// Call this first! Connects to the spreadsheet.
  Future<void> init() async {
    _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
  }

  /// Adds a row of data to the bottom of the sheet.
  /// 
  /// [sheetName] defaults to "Sheet1".
  Future<void> add(List<dynamic> row, {String sheetName = 'Sheet1'}) async {
    final sheet = await _getSheet(sheetName);
    await sheet.values.appendRow(row);
  }

  /// Reads all data as a List of Maps.
  /// 
  /// Assumes the FIRST row contains headers (Keys).
  /// Example: 
  /// Row 1: Name, Age
  /// Row 2: Karan, 24
  /// Result: [{'Name': 'Karan', 'Age': '24'}]
  Future<List<Map<String, dynamic>>> read({String sheetName = 'Sheet1'}) async {
    final sheet = await _getSheet(sheetName);
    final rows = await sheet.values.map.allRows();
    return rows ?? [];
  }

  /// Helper: Gets or creates the worksheet.
  Future<Worksheet> _getSheet(String title) async {
    Worksheet? sheet = _spreadsheet.worksheetByTitle(title);
    if (sheet == null) {
      // If not found, try to create it? Or throw?
      // Let's create it for "Rookie Friendly" mode.
      sheet = await _spreadsheet.addWorksheet(title);
    }
    return sheet;
  }
}
