import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markAttendance({
    required String studentId,
    required DateTime date,
    required int period,
    required String subject,
    required String paperCode,
    required bool isPresent,
    required int semester, // ✅ New: Semester added
  }) async {
    try {
      String dateKey =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      String periodKey = "P$period";

      DocumentReference studentRef =
          _firestore.collection('students').doc(studentId);

      await studentRef.set({
        'attendance': {
          'semester_$semester': {
            // ✅ Stores under correct semester
            dateKey: {
              periodKey: {
                'subject': subject,
                'paper_code': paperCode,
                'is_present': isPresent,
              }
            }
          }
        }
      }, SetOptions(merge: true)); // ✅ Merges data without overwriting

      print(
          "✅ Attendance marked for $studentId on $dateKey Period: $period in Semester: $semester");
      notifyListeners();
    } catch (e) {
      print("❌ Error marking attendance: $e");
    }
  }

  Future<Map<String, bool>> fetchAttendanceForDate(
      String subject, int semester, DateTime date, int period) async {
    try {
      String dateKey =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      String periodKey = "P$period";
      String semesterKey = "semester_$semester";

      print("Fetching attendance for:");
      print("Subject: $subject");
      print("Semester: $semesterKey");
      print("Date: $dateKey");
      print("Period: $periodKey");

      // Step 1: Fetch all students assigned to this subject
      QuerySnapshot studentSnapshot = await _firestore
          .collection('students')
          .where('assigned_subjects', arrayContains: subject)
          .get();

      if (studentSnapshot.docs.isEmpty) {
        print("No students found for this subject.");
        return {};
      }

      Map<String, bool> attendanceData = {};

      // Step 2: Loop through each student and fetch their attendance
      for (var doc in studentSnapshot.docs) {
        String studentId = doc.id;
        var studentData = doc.data() as Map<String, dynamic>?;

        if (studentData == null || !studentData.containsKey('attendance')) {
          print("No attendance data for student: $studentId");
          continue;
        }

        var attendanceRecords =
            studentData['attendance'] as Map<String, dynamic>;

        if (!attendanceRecords.containsKey(semesterKey)) {
          print(
              "No attendance found for semester: $semesterKey in student: $studentId");
          continue;
        }

        var semesterRecords =
            attendanceRecords[semesterKey] as Map<String, dynamic>;

        if (!semesterRecords.containsKey(dateKey)) {
          print(
              "No attendance found for date: $dateKey in student: $studentId");
          continue;
        }

        var dateRecords = semesterRecords[dateKey] as Map<String, dynamic>;

        if (!dateRecords.containsKey(periodKey)) {
          print(
              "No attendance found for period: $periodKey in student: $studentId");
          continue;
        }

        var periodData = dateRecords[periodKey] as Map<String, dynamic>;

        if (periodData['subject'] != subject) {
          print("Subject mismatch for student: $studentId");
          continue;
        }

        attendanceData[studentId] = periodData['is_present'] ?? false;
      }

      print("Fetched Attendance Data: $attendanceData");
      return attendanceData;
    } catch (e) {
      print("Error fetching attendance: $e");
      return {};
    }
  }
}
