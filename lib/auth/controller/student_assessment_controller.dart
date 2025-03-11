import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentAssessmentController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches assessments for a specific student and semester
  Future<List<Map<String, dynamic>>> getAssessments(
      String studentId, int semester) async {
    try {
      String semesterKey = "semester_$semester";

      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await _firestore.collection('students').doc(studentId).get();

      if (!studentSnapshot.exists) {
        return []; // No student record found
      }

      var studentData = studentSnapshot.data();
      if (studentData == null ||
          !studentData.containsKey('assessments') ||
          !(studentData['assessments'] is Map<String, dynamic>) ||
          !studentData['assessments'].containsKey(semesterKey)) {
        return []; // No assessments found
      }

      // Extract and return assessments list
      var semesterAssessments = studentData['assessments'][semesterKey];

      if (semesterAssessments is List) {
        return List<Map<String, dynamic>>.from(semesterAssessments);
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching assessments: $e");
      return [];
    }
  }

  /// Retrieves the available semesters from the student's assessment records
  Future<List<int>> getAvailableSemesters(String studentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await _firestore.collection('students').doc(studentId).get();

      if (!studentSnapshot.exists) {
        return [];
      }

      var studentData = studentSnapshot.data();
      if (studentData == null || !studentData.containsKey('assessments')) {
        return [];
      }

      var assessments = studentData['assessments'];
      if (assessments is! Map<String, dynamic>) {
        return [];
      }

      // Extract semester keys and convert them to integers
      List<int> availableSemesters = assessments.keys
          .where((key) => key
              .startsWith("semester_")) // Ensure it follows the expected format
          .map<int>(
              (key) => int.tryParse(key.replaceFirst("semester_", "")) ?? 0)
          .where((sem) => sem > 0) // Remove invalid semesters
          .toList();

      print("Fetched Available Semesters: $availableSemesters");
      return availableSemesters;
    } catch (e) {
      print("Error fetching available semesters: $e");
      return [];
    }
  }
}
