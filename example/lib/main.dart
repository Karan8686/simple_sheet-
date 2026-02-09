import 'package:flutter/material.dart';
import 'package:simple_sheets/simple_sheets.dart';

void main() {
  runApp(const MaterialApp(home: SimpleSheetsDemo()));
}

class SimpleSheetsDemo extends StatefulWidget {
  const SimpleSheetsDemo({super.key});

  @override
  State<SimpleSheetsDemo> createState() => _SimpleSheetsDemoState();
}

class _SimpleSheetsDemoState extends State<SimpleSheetsDemo> {
  // Controllers
  final _credController = TextEditingController();
  final _idController = TextEditingController();
  
  // State
  SimpleSheets? _sheets;
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = false;
  String _status = "Not Connected";

  Future<void> _connect() async {
    setState(() => _isLoading = true);
    try {
      _sheets = SimpleSheets(
        credentials: _credController.text,
        spreadsheetId: _idController.text,
      );
      await _sheets!.init();
      setState(() => _status = "Connected!");
      _fetchData();
    } catch (e) {
      setState(() => _status = "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchData() async {
    if (_sheets == null) return;
    setState(() => _isLoading = true);
    try {
      final data = await _sheets!.read();
      setState(() => _data = data);
    } catch (e) {
      setState(() => _status = "Read Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addRow() async {
    if (_sheets == null) return;
    setState(() => _isLoading = true);
    try {
      // Adding a dummy row
      await _sheets!.add([
        "User ${DateTime.now().second}", // Name
        "${DateTime.now().millisecond}", // ID
        "Flutter Dev"                    // Role
      ]);
      await _fetchData(); // Refresh UI
    } catch (e) {
      setState(() => _status = "Write Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SimpleSheets Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Config Section
            TextField(
              controller: _credController,
              decoration: const InputDecoration(
                labelText: "Paste Google Cloud JSON Credentials",
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: "Spreadsheet ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _connect,
              child: Text(_isLoading ? "Connecting..." : "Connect to Sheet"),
            ),
            
            const Divider(),
            Text("Status: $_status"),
            const Divider(),

            // Data View
            Expanded(
              child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final row = _data[index];
                  return ListTile(
                    title: Text(row.values.join(" | ")),
                    subtitle: Text("Row $index"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _addRow,
        child: const Icon(Icons.add),
      ),
    );
  }
}
