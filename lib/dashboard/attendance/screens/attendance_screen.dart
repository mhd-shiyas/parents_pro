import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../controller/students_attendance_controller.dart';

class AttendanceScreen extends StatefulWidget {
  final String studentId;

  const AttendanceScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int selectedSemester = 1;
  List<String> availableMonths = [];
  String selectedMonth = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchAvailableMonths();
  }

  void _fetchAvailableMonths() async {
    availableMonths =
        await Provider.of<StudentsAttendanceController>(context, listen: false)
            .getAvailableMonths(widget.studentId, selectedSemester);
    if (availableMonths.isNotEmpty) {
      selectedMonth = availableMonths.first;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Hourly"),
            Tab(text: "Subject"),
            Tab(text: "Semester"),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSemesterDropdown(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHourlyAttendance(),
                _buildSubjectAttendance(),
                _buildSemesterAttendance(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Semester",
              style: GoogleFonts.montserrat(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          DropdownButton<int>(
            value: selectedSemester,
            items: List.generate(8, (index) => index + 1)
                .map((sem) => DropdownMenuItem(
                      value: sem,
                      child: Text("Semester $sem"),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedSemester = value;
                  _fetchAvailableMonths();
                });
              }
            },
          ),
        ],
      ),
    );
  }

 Widget _buildHourlyAttendance() {
  return Column(
    children: [
      _buildMonthSelector(), // Month dropdown
      Expanded(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: Provider.of<StudentsAttendanceController>(context)
              .getHourlyAttendance(widget.studentId, selectedSemester, selectedMonth),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No Attendance Data Found"));
            }

            final attendanceList = snapshot.data!;

            return ListView.builder(
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                final attendanceEntry = attendanceList[index];
                final date = attendanceEntry['date']; // Day name + date
                final periods = attendanceEntry['periods'] as Map<String, bool>;

                return ListTile(
                  title: Text(date), // Now formatted with day name
                  subtitle: Row(
                    children: List.generate(5, (periodIndex) {
                      String periodKey = "P${periodIndex + 1}";
                      Color color = Colors.grey;

                      if (periods.containsKey(periodKey)) {
                        color = periods[periodKey]! ? Colors.green : Colors.red;
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      );
                    }),
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  );
}

  Widget _buildMonthSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: availableMonths.map((month) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMonth = month;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                month,
                style: TextStyle(
                  fontWeight: selectedMonth == month
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: selectedMonth == month ? Colors.black : Colors.grey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubjectAttendance() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Provider.of<StudentsAttendanceController>(context, listen: false)
          .getSubjectWiseAttendance(widget.studentId, selectedSemester),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No Attendance Data Found"));
        }

        final subjects = snapshot.data!;

        return ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];

            String subjectName = subject['subject'];
            int totalHours = subject['total_hours'] ??
                0; // Total times attendance was marked
            int attendedHours = subject['attended_hours'] ??
                0; // Total times student was present

            // Calculate percentage safely
            double attendancePercentage =
                (totalHours > 0) ? (attendedHours / totalHours) * 100 : 0.0;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subjectName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text("Total Hours: $totalHours"),
                    Text("Attended Hours: $attendedHours"),
                    SizedBox(height: 10),
                    CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 5.0,
                      percent: (attendancePercentage / 100).clamp(0.0, 1.0),
                      center:
                          Text("${attendancePercentage.toStringAsFixed(1)}%"),
                      progressColor:
                          attendancePercentage < 75 ? Colors.red : Colors.green,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSemesterAttendance() {
    return Consumer<StudentsAttendanceController>(
      builder: (context, controller, child) {
        return FutureBuilder<Map<String, dynamic>>(
          future: controller.getSemesterAttendance(
              widget.studentId, selectedSemester),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No Attendance Data Found"));
            }

            final data = snapshot.data!;

            int totalHours = data["totalHours"];
            int attendedHours = data["attendedHours"];
            double percentage = data["percentage"];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Semester Attendance",
                  style: GoogleFonts.montserrat(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 8.0,
                  percent: percentage / 100,
                  center: Text("${percentage.toStringAsFixed(1)}%"),
                  progressColor: percentage < 75 ? Colors.red : Colors.green,
                ),
                SizedBox(height: 16),
                Text(
                  "Total Hours: $totalHours",
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Attended Hours: $attendedHours",
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                if (percentage < 75)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "⚠️ Your child's attendance is below 75%",
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
