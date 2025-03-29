import 'dart:convert'; // For json encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VehicleDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> vehicleData;

  VehicleDetailsScreen({required this.vehicleData});

  @override
  Widget build(BuildContext context) {
    // Handle null safety for missing values
    String numberPlate = vehicleData["number_plate"] ?? "N/A";
    String ownerName = vehicleData["owner_name"] ?? "N/A";
    String fuelType = vehicleData["fuel_type"] ?? "N/A";
    String companyname = vehicleData["company_name"] ?? "N/A";
    String fuelstatus = vehicleData["status"] ?? "N/A";

    // Create a TextEditingController to manage the liters input
    TextEditingController litersController = TextEditingController();

    // Function to send POST request to backend
    Future<void> sendRefuelingData(String numberPlate, String liters) async {
      // Define the URL of your backend endpoint
      final String apiUrl = "http://192.168.1.2:8000/api/refueling";  // Replace with your actual backend URL

      // Create the JSON payload
      final Map<String, dynamic> refuelingData = {
        "number_plate": numberPlate,
        "liters": liters,
      };

      // Send the POST request
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(refuelingData), // Convert the data to JSON
        );

        if (response.statusCode == 201) {
          // If the response is successful, parse the response
          final responseData = jsonDecode(response.body);

          // Display the refueling bill in a dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Refueling Details"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Number Plate: ${responseData['data']['number_plate']}"),
                    Text("Liters Refueled: ${responseData['data']['liters']}"),
                    Text("Fuel Type: ${responseData['data']['fuel_type']}"),
                    Text("Total Price: Rs: ${responseData['data']['total_price']}"),
                    Text("Total Discount: Rs: ${responseData['data']['total_discount']}"),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // If the response is not successful, show an error message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Failed to record refueling data. Please try again."),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        // Handle network or other errors
        print("Error: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("An error occurred while sending the request."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Vehicle Details")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Number Plate: $numberPlate",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Owner Name: $ownerName", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Fuel Type: $fuelType", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Company Name: $companyname", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Fuel Status: $fuelstatus", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),

            // Add a form for entering the number of liters refueled
            Text("Enter Liters Refueled", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextFormField(
              controller: litersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Liters",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                // Simple validation for non-empty value
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of liters';
                }
                // Check if the input is a valid number
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 20),

            // Button to submit the form
            ElevatedButton(
              onPressed: () {
                // Retrieve the liters value from the controller
                String liters = litersController.text;
                // Optionally, do something with the value (e.g., save it, display it, etc.)
                if (liters.isNotEmpty && double.tryParse(liters) != null) {
                  // Send data to the backend
                  sendRefuelingData(numberPlate, liters);
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
