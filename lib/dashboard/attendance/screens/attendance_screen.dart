import 'package:flutter/material.dart';

import '../../../common/custom_appbar.dart';

class AttendanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Attendance"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Semester Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Semester',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: 'Fifth',
                  items: [
                    DropdownMenuItem(
                      value: 'Fifth',
                      child: Text('Fifth'),
                    ),
                    DropdownMenuItem(
                      value: 'Sixth',
                      child: Text('Sixth'),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
            SizedBox(height: 16),

            // Tabs for Attendance Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton('Paper', true),
                _buildTabButton('Hourly', false),
                _buildTabButton('Termly', false),
              ],
            ),
            SizedBox(height: 16),

            // Attendance Cards
            Expanded(
              child: ListView(
                children: [
                  _buildAttendanceCard(
                    code: 'BCS5009',
                    subject: 'Web Programming Using PHP',
                    faculty: 'Fathimath Summayya O',
                    totalHours: 88,
                    attendedHours: 88,
                    percentage: 75,
                  ),
                  _buildAttendanceCard(
                    code: 'BCS5007',
                    subject: 'Computer Organization',
                    faculty: 'Sreevidya NR',
                    totalHours: 88,
                    attendedHours: 88,
                    percentage: 75,
                  ),
                  _buildAttendanceCard(
                    code: 'BCS5010',
                    subject: 'Java Programming',
                    faculty: 'Sruthi VS',
                    totalHours: 88,
                    attendedHours: 88,
                    percentage: 75,
                  ),
                  _buildAttendanceCard(
                    code: 'BCS5009',
                    subject: 'Web Programming Using PHP',
                    faculty: 'Fathimath Summayya O',
                    totalHours: 88,
                    attendedHours: 88,
                    percentage: 75,
                  ),
                ],
              ),
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
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildTabButton(String label, bool isActive) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.teal : Colors.grey[300],
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

  Widget _buildAttendanceCard({
    required String code,
    required String subject,
    required String faculty,
    required int totalHours,
    required int attendedHours,
    required int percentage,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    code,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  subject,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(faculty),
                SizedBox(height: 8),
                Text('Total Hours: $totalHours'),
                Text('Attended Hours: $attendedHours'),
              ],
            ),
          ),
          SizedBox(width: 16),
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                  ),
                  Text('$percentage%',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
