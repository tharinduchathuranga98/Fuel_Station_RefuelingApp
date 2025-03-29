import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RefuelingScreen extends StatefulWidget {
  final String numberPlate; // Pass the vehicle number plate

  RefuelingScreen({required this.numberPlate});

  @override
  _RefuelingScreenState createState() => _RefuelingScreenState();
}

class _RefuelingScreenState extends State<RefuelingScreen> {
  final TextEditingController _litersController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _submitRefueling() async {
    final String liters = _litersController.text;

    if (liters.isEmpty) {
      setState(() {
        _errorMessage = "Please enter the number of liters.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String apiUrl = "http://127.0.0.1:8000/api/refueling"; // Update with your API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "number_plate": widget.numberPlate,
          "liters": liters,
        }),
      );

      if (response.statusCode == 201) {
        // Successfully recorded refueling
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // Show success message (you can handle this differently)
        _showSuccessDialog(jsonResponse['message']);
      } else {
        // Failed to record refueling
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          _errorMessage = jsonResponse['error'] ?? "An error occurred.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context); // Go back to previous screen (e.g., scan screen)
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record Refueling"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Number Plate: ${widget.numberPlate}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _litersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Liters of Fuel",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitRefueling,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Submit Refueling"),
            ),
          ],
        ),
      ),
    );
  }
}
