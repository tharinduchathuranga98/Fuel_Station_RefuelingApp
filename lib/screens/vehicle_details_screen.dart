import 'package:flutter/material.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> vehicleData;

  VehicleDetailsScreen({required this.vehicleData});

  @override
  Widget build(BuildContext context) {
    // Handle null safety for missing values
    String numberPlate = vehicleData["number_plate"] ?? "N/A";
    String ownerName = vehicleData["owner_name"] ?? "N/A";
    String fuelType = vehicleData["fuel_type"] ?? "N/A";

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
          ],
        ),
      ),
    );
  }
}
