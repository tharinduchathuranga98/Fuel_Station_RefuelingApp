import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15), // More space at bottom
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Rounded corners
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent, // Removes background color
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Light floating effect
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent, // Fully transparent
            selectedItemColor: Colors.orange, // Highlight selected item
            unselectedItemColor: Colors.white,
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            elevation: 0, // No default shadow
            type: BottomNavigationBarType.fixed, // Keeps icons aligned
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
