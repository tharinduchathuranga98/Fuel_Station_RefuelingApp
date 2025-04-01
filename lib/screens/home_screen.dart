import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Add this package for date formatting
import '../config.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> refuelingRecords = [];
  bool isLoading = true;
  String errorMessage = '';
  bool isLatestFirst = true; // Add a state variable to track the sorting order

  @override
  void initState() {
    super.initState();
    fetchRefuelingRecords();
  }

  Future<void> fetchRefuelingRecords() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final String apiUrl = Config.baseUrl + Config.refuelingrecords;

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          refuelingRecords = responseData['data'];
          isLoading = false;
        });
        _sortRecords(); // Sort records based on the current order
      } else {
        setState(() {
          errorMessage = "No refueling records found.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Connection error. Please check your network.";
        isLoading = false;
      });
    }
  }

  void _sortRecords() {
    setState(() {
      if (isLatestFirst) {
        refuelingRecords.sort((a, b) => DateTime.parse(b['refueled_at'])
            .compareTo(DateTime.parse(a['refueled_at']))); // Sort by latest first
      } else {
        refuelingRecords.sort((a, b) => DateTime.parse(a['refueled_at'])
            .compareTo(DateTime.parse(b['refueled_at']))); // Sort by latest last
      }
    });
  }

  // Function to toggle sorting when the filter button is pressed
  void _toggleSortOrder() {
    setState(() {
      isLatestFirst = !isLatestFirst; // Toggle the sort order
      _sortRecords(); // Re-sort the records based on the new order
    });
  }

  String _formatCurrency(dynamic amount) {
    return NumberFormat.currency(
      symbol: 'Rs',
      decimalDigits: 2,
    ).format(double.parse(amount.toString()));
  }

  String _formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString).toLocal();
    return DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
  }

  Color _getFuelTypeColor(String fuelType) {
    switch (fuelType.toLowerCase()) {
      case 'petrol':
        return Colors.green;
      case 'diesel':
        return Colors.amber;
      case 'cng':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 3, 3),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Fuel Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 46, 10, 107),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchRefuelingRecords,
            tooltip: 'Refresh data',
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _toggleSortOrder, // Toggle the sort order when pressed
            tooltip: 'Filter records',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchRefuelingRecords,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Summary card
              if (!isLoading && refuelingRecords.isNotEmpty)
                _buildSummaryCard(),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Refueling History",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (!isLoading && refuelingRecords.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        // Add functionality to view all records
                      },
                      icon: Icon(Icons.history, size: 16),
                      label: Text("View All"),
                    ),
                ],
              ),

              SizedBox(height: 10),

              // Records list
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    // Calculate total spent
    double totalSpent = 0;
    for (var record in refuelingRecords) {
      totalSpent += double.parse(record['total_price'].toString());
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              Icons.local_gas_station,
              '${refuelingRecords.length}',
              'Total Refills',
              Colors.deepPurple,
            ),
            VerticalDivider(thickness: 1, color: Colors.grey.shade300),
            _buildSummaryItem(
              Icons.monetization_on,
              _formatCurrency(totalSpent),
              'Total Income',
              Colors.green.shade700,
            ),
            VerticalDivider(thickness: 1, color: Colors.grey.shade300),
            _buildSummaryItem(
              Icons.calendar_today,
              '${DateFormat('MMM').format(DateTime.now())}',
              'This Month',
              Colors.blue.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.deepPurple),
            SizedBox(height: 16),
            Text(
              "Loading refueling records...",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(errorMessage, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(Icons.refresh),
              label: Text("Try Again"),
              onPressed: fetchRefuelingRecords,
            ),
          ],
        ),
      );
    }

    if (refuelingRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_gas_station, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              "No refueling records yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Tap the QR button to add your first record",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: refuelingRecords.length,
      itemBuilder: (context, index) {
        final record = refuelingRecords[index];
        final Color fuelColor = _getFuelTypeColor(record['fuel_type_name']);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Add functionality to view details
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: fuelColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_gas_station,
                                  size: 16,
                                  color: fuelColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  record['fuel_type_name'],
                                  style: TextStyle(
                                    color: fuelColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "${record['liters']} L",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _formatCurrency(record['total_price']),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            record['number_plate'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (double.parse(record['total_discount'].toString()) > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Saved: ${_formatCurrency(record['total_discount'])}",
                            style: TextStyle(
                              color: Colors.red[800],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Text(
                        _formatDate(record['refueled_at']),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
