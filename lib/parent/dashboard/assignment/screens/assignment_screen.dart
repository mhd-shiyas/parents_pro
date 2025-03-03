import 'package:flutter/material.dart';

import '../../../../common/custom_appbar.dart';

class AssignmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Assignment"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton('Assignment', true),
                _buildTabButton('Seminar', false),
              ],
            ),
            SizedBox(height: 24),

            // Upcoming Assignments Section
            Text(
              'Upcoming Assignment:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildAssignmentCard(
              'Note submission',
              'Python programming',
              '10-12-2024',
              Colors.red,
            ),
            SizedBox(height: 8),
            _buildAssignmentCard(
              'Note submission',
              'Data structure',
              '10-12-2024',
              Colors.red,
            ),

            SizedBox(height: 24),

            // Submitted Assignments Section
            Text(
              'Submitted Assignment:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildAssignmentCard(
              'Note Submitted',
              'Java programming',
              'Submitted',
              Colors.green,
            ),
            SizedBox(height: 8),
            _buildAssignmentCard(
              'Note Submitted',
              'Software Engineering',
              'Submitted',
              Colors.green,
              showIcon: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildTabButton(String label, bool isActive) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(
    String title,
    String subtitle,
    String date,
    Color color, {
    bool showIcon = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.book, color: color, size: 30),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 14)),
                Text(date, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          if (showIcon)
            Icon(
              Icons.check_circle,
              color: color,
              size: 30,
            ),
        ],
      ),
    );
  }
}
