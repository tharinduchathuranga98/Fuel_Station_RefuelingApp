import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'vehicle_details_screen.dart'; // Import the next page

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isFlashOn = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // QR Code Scanner View
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.orange,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 280.0,
            ),
            cameraFacing: CameraFacing.back,
          ),

          // Branding Logo Positioned at the Top
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 80,
                ),
                Text(
                  'FUEL DISCOUNT',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Centered Flash Button
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _toggleFlash,
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 30,
                  child: Icon(
                    isFlashOn ? Icons.flash_off : Icons.flash_on,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 void _onQRViewCreated(QRViewController controller) {
  this.controller = controller;
  controller.scannedDataStream.listen((scanData) {
    setState(() {
      result = scanData;
    });

    // Check if the result is not null before passing it
    if (result?.code != null) {
      _handleScan(result!.code!);
    }
  });
}

  void _handleScan(String numberPlate) async {
  final String apiUrl = "http://192.168.1.2:8000/api/check-vehicle"; // Replace with correct IP

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"number_plate": numberPlate}),
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.containsKey("data") && jsonResponse["data"] != null) {
        final vehicleData = jsonResponse["data"];
        print("Extracted Data: $vehicleData");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetailsScreen(vehicleData: vehicleData),
          ),
        );
      } else {
        print("Error: No 'data' key found in response");
        _showErrorDialog();
      }
    } else {
      print("Vehicle Not Found");
      _showErrorDialog();
    }
  } catch (e) {
    print("Error: $e");
    _showErrorDialog();
  }
}



  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invalid QR Code"),
          content: Text("The scanned QR code is not associated with a vehicle."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                controller?.resumeCamera(); // Resume scanning
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleFlash() async {
    if (controller != null) {
      await controller!.toggleFlash();
      bool? flashStatus = await controller!.getFlashStatus();
      setState(() {
        isFlashOn = flashStatus ?? false;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
