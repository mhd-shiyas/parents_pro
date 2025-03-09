import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/teacher_model.dart';
import '../repository/teacher_repository.dart';

class TeacherController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TeacherRepository _teacherRepository = TeacherRepository();

  Map<String, dynamic>? _teacherData;
  bool _isLoading = false;

  Map<String, dynamic>? get teacherData => _teacherData;
  bool get isLoading => _isLoading;

  // Fetch the teacher’s data based on their ID
  Future<void> fetchTeacherDetails(String teacherId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _teacherData = await _teacherRepository.getTeacherDetails(teacherId);
    } catch (e) {
      _teacherData = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Teacher?> getTeacherById(String teacherId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('teachers').doc(teacherId).get();
      if (doc.exists) {
        return Teacher.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print("Teacher not found");
        return null;
      }
    } catch (e) {
      print("Error fetching teacher: $e");
      return null;
    }
  }

  // List<Teacher> _teachers = [];

  // List<Teacher> get teachers => _teachers;

  // Future<void> loadTeachers() async {
  //   try {
  //     QuerySnapshot querySnapshot =
  //         await _firestore.collection('teachers').get();
  //     _teachers = querySnapshot.docs
  //         .map((doc) => Teacher.fromMap(doc.data() as Map<String, dynamic>))
  //         .toList();
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error loading teachers: $e");
  //   }
  // }

  // Future<void> assignPeriod(String teacherId, String semester, String subject, String department, String paperCode) async {
  //   try {
  //     DocumentReference teacherRef = _firestore.collection('teachers').doc(teacherId);
  //     await teacherRef.update({
  //       'assigned_periods': FieldValue.arrayUnion([
  //         {'semester': semester, 'subject': subject, 'department': department, 'paper_code': paperCode}
  //       ])
  //     });
  //     print("Period assigned successfully");
  //     loadTeachers();
  //   } catch (e) {
  //     print("Error assigning period: $e");
  //   }
  // }
}
