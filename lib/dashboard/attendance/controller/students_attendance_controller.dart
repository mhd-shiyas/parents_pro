import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parent_pro/dashboard/attendance/repository/student_attendance_repository.dart';

class StudentsAttendanceController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final StudentsAttendanceRepository _attendanceRepository =
      StudentsAttendanceRepository();
  double _overallAttendance = 0.0;
  double get overallAttendance => _overallAttendance;

  /// Stores all attendance records fetched
  Map<String, dynamic> _attendanceData = {};

  /// List of unique months extracted from attendance data
  List<String> _availableMonths = [];

  /// Getters
  Map<String, dynamic> get attendanceData => _attendanceData;
  List<String> get availableMonths => _availableMonths;

  Future<Map<int, bool?>> fetchTodaysAttendance(String studentId) async {
    try {
      String dateKey = DateTime.now()
          .toLocal()
          .toString()
          .split(' ')[0]; // Format: YYYY-MM-DD

      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await _firestore.collection('students').doc(studentId).get();

      if (!studentSnapshot.exists) {
        print("❌ No student record found for ID: $studentId");
        return {};
      }

      var studentData = studentSnapshot.data();
      if (studentData == null || !studentData.containsKey('attendance')) {
        print("❌ No attendance data found for student: $studentId");
        return {};
      }

      print(
          "✅ Found Attendance Data for Student: $studentId → ${studentData['attendance']}");

      // Loop through all semesters inside attendance
      for (var semesterKey in studentData['attendance'].keys) {
        var semesterAttendance =
            studentData['attendance'][semesterKey] as Map<String, dynamic>;

        if (semesterAttendance.containsKey(dateKey)) {
          // Extract today's attendance
          var dateAttendance =
              semesterAttendance[dateKey] as Map<String, dynamic>;
          Map<int, bool?> attendanceData = {};

          print(
              "📅 Found Attendance for Date: $dateKey in Semester: $semesterKey");

          // Convert period keys ("P1", "P2") into integer keys (1, 2, 3...)
          dateAttendance.forEach((periodKey, periodData) {
            if (periodData is Map<String, dynamic> &&
                periodData.containsKey('is_present')) {
              int? periodNumber =
                  int.tryParse(periodKey.substring(1)); // Convert "P1" -> 1
              if (periodNumber != null) {
                attendanceData[periodNumber] = periodData['is_present'];
              }
            }
          });

          print("🎯 Final Fetched Attendance for $dateKey → $attendanceData");
          return attendanceData; // Return the first found attendance
        }
      }

      print("⚠️ No attendance marked for today's date: $dateKey");
      return {}; // No attendance found for today
    } catch (e) {
      print("🚨 Error fetching today's attendance: $e");
      return {};
    }
  }

  Future<List<String>> getAvailableMonths(
      String studentId, int semester) async {
    try {
      DocumentSnapshot studentSnapshot =
          await _firestore.collection('students').doc(studentId).get();

      if (!studentSnapshot.exists) return [];

      var studentData = studentSnapshot.data() as Map<String, dynamic>?;
      if (studentData == null || !studentData.containsKey('attendance'))
        return [];

      var attendanceData = studentData['attendance'] as Map<String, dynamic>;
      String semesterKey = "semester_$semester";

      if (!attendanceData.containsKey(semesterKey)) return [];

      var semesterAttendance =
          attendanceData[semesterKey] as Map<String, dynamic>;

      // Extract unique month names
      Set<String> months = semesterAttendance.keys.map((date) {
        DateTime parsedDate = DateTime.parse(date);
        return DateFormat('MMMM').format(parsedDate); // Converts to "March"
      }).toSet();

      return months.toList();
    } catch (e) {
      print("Error fetching available months: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getHourlyAttendance(
      String studentId, int semester, String selectedMonth) async {
    try {
      DocumentSnapshot studentSnapshot =
          await _firestore.collection('students').doc(studentId).get();

      if (!studentSnapshot.exists) return [];

      var studentData = studentSnapshot.data() as Map<String, dynamic>?;
      if (studentData == null || !studentData.containsKey('attendance'))
        return [];

      var attendanceData = studentData['attendance'] as Map<String, dynamic>;
      String semesterKey = "semester_$semester";

      if (!attendanceData.containsKey(semesterKey)) return [];

      var semesterAttendance =
          attendanceData[semesterKey] as Map<String, dynamic>;

      List<Map<String, dynamic>> formattedAttendance = [];

      semesterAttendance.forEach((date, periods) {
        DateTime parsedDate = DateTime.parse(date);
        String monthName = DateFormat('MMMM').format(parsedDate);
        String dayName = DateFormat('EEEE, d MMMM')
            .format(parsedDate); // Example: "Monday, 9 March"

        if (monthName == selectedMonth) {
          Map<String, bool> periodStatus = {};

          (periods as Map<String, dynamic>).forEach((periodKey, periodData) {
            if (periodData is Map<String, dynamic> &&
                periodData.containsKey('is_present')) {
              periodStatus[periodKey] = periodData['is_present'];
            }
          });

          formattedAttendance.add({
            'date': dayName, // Now includes day name
            'periods': periodStatus,
          });
        }
      });

      return formattedAttendance;
    } catch (e) {
      print("Error fetching hourly attendance: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSubjectWiseAttendance(
      String studentId, int selectedSemester) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await _firestore.collection('students').doc(studentId).get();

      if (!studentSnapshot.exists) {
        return []; // No student record found
      }

      var studentData = studentSnapshot.data();
      if (studentData == null ||
          !studentData.containsKey('attendance') ||
          !studentData['attendance']
              .containsKey('semester_$selectedSemester')) {
        return []; // No attendance data for the selected semester
      }

      // Extract semester attendance
      var semesterAttendance = studentData['attendance']
          ['semester_$selectedSemester'] as Map<String, dynamic>;

      Map<String, int> totalHoursMap =
          {}; // Key: Subject, Value: Total attendance marked
      Map<String, int> attendedHoursMap =
          {}; // Key: Subject, Value: Present count

      // Loop through each date's attendance
      semesterAttendance.forEach((dateKey, dateAttendance) {
        if (dateAttendance is Map<String, dynamic>) {
          dateAttendance.forEach((periodKey, periodData) {
            if (periodData is Map<String, dynamic> &&
                periodData.containsKey('subject') &&
                periodData.containsKey('is_present')) {
              String subject = periodData['subject'];
              bool isPresent = periodData['is_present'];

              // Increment total hours for the subject
              totalHoursMap[subject] = (totalHoursMap[subject] ?? 0) + 1;

              // Increment attended hours if student was present
              if (isPresent) {
                attendedHoursMap[subject] =
                    (attendedHoursMap[subject] ?? 0) + 1;
              }
            }
          });
        }
      });

      // Prepare the final result list
      List<Map<String, dynamic>> subjectAttendanceList = [];

      totalHoursMap.forEach((subject, totalHours) {
        int attendedHours = attendedHoursMap[subject] ?? 0;
        double attendancePercentage =
            (totalHours > 0) ? (attendedHours / totalHours) * 100 : 0.0;

        subjectAttendanceList.add({
          'subject': subject,
          'total_hours': totalHours,
          'attended_hours': attendedHours,
          'percentage': attendancePercentage,
        });
      });

      return subjectAttendanceList;
    } catch (e) {
      print("Error fetching subject-wise attendance: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> getSemesterAttendance(
      String studentId, int semester) async {
    try {
      String semesterKey = "semester_$semester";

      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await _firestore.collection('students').doc(studentId).get();

      if (!studentSnapshot.exists) {
        return {"totalHours": 0, "attendedHours": 0, "percentage": 0.0};
      }

      var studentData = studentSnapshot.data();
      if (studentData == null ||
          !studentData.containsKey('attendance') ||
          !studentData['attendance'].containsKey(semesterKey)) {
        return {"totalHours": 0, "attendedHours": 0, "percentage": 0.0};
      }

      // Fetch attendance records for the semester
      var semesterAttendance =
          studentData['attendance'][semesterKey] as Map<String, dynamic>;

      int totalHours = 0;
      int attendedHours = 0;

      // Loop through all dates in the semester
      semesterAttendance.forEach((dateKey, periods) {
        if (periods is Map<String, dynamic>) {
          periods.forEach((periodKey, periodData) {
            if (periodData is Map<String, dynamic> &&
                periodData.containsKey('is_present')) {
              totalHours++; // Count total periods recorded
              if (periodData['is_present'] == true) {
                attendedHours++; // Count periods where the student was present
              }
            }
          });
        }
      });

      double percentage =
          totalHours == 0 ? 0.0 : (attendedHours / totalHours) * 100;

      return {
        "totalHours": totalHours,
        "attendedHours": attendedHours,
        "percentage": percentage,
      };
    } catch (e) {
      print("Error fetching semester attendance: $e");
      return {"totalHours": 0, "attendedHours": 0, "percentage": 0.0};
    }
  }
}
