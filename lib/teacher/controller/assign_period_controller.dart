import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/teacher_model.dart';

class AssignPeriodController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _teacherData;
  bool _isLoading = false;

  Map<String, dynamic>? get teacherData => _teacherData;
  bool get isLoading => _isLoading;

  List<Teacher> _teachers = [];

  List<Teacher> get teachers => _teachers;

  Future<void> loadTeachers() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('teachers').get();
      _teachers = querySnapshot.docs
          .map((doc) => Teacher.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error loading teachers: $e");
    }
  }

  Future<void> assignPeriod(String teacherId, int semester, String subject,
      String department, String paperCode) async {
    try {
      DocumentReference teacherRef =
          _firestore.collection('teachers').doc(teacherId);
      await teacherRef.update({
        'assigned_periods': FieldValue.arrayUnion([
          {
            'semester': semester,
            'subject': subject,
            'department': department,
            'paper_code': paperCode
          }
        ])
      });
      print("Period assigned successfully");
      loadTeachers();
    } catch (e) {
      print("Error assigning period: $e");
    }
  }
}
