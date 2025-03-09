import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parent_pro/teacher/model/student_model.dart';

import '../repository/students_repository.dart';

class StudentController with ChangeNotifier {
  final StudentRepository _repository = StudentRepository();
  List<StudentModel> _students = [];
  List<StudentModel> get students => _students;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadAllStudents() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('students').get();
      _students = querySnapshot.docs
          .map(
              (doc) => StudentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error loading all students: $e");
    }
  }

  Future<void> loadStudents(String department) async {
    try {
      _students = await _repository.fetchStudents(department);
      notifyListeners();
    } catch (e) {
      print("Error loading students: $e");
    }
  }

  Future<void> addStudent(StudentModel student, String password) async {
    try {
      await _repository.addStudent(student, password);
      loadStudents(
          student.department!); // Reload students after adding a new one
    } catch (e) {
      print("Error adding student: $e");
    }
  }

  Future<void> updateStudent(
      String studentId, Map<String, dynamic> updatedData) async {
    try {
      await _repository.updateStudent(studentId, updatedData);
      int index =
          _students.indexWhere((student) => student.studentId == studentId);
      if (index != -1) {
        _students[index] = StudentModel.fromMap({
          ..._students[index].toMap(),
          ...updatedData,
        });
        ;
        notifyListeners();
      } else {}
    } catch (e) {
      print("Error updating student: $e");
    }
  }

  Future<List<StudentModel>> loadStudentsBySubject(String subject) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('students')
          .where('assigned_subjects', arrayContains: subject)
          .get();

      List<StudentModel> students = querySnapshot.docs
          .map((doc) {
            try {
              return StudentModel.fromMap(doc.data());
            } catch (e) {
              print("Error parsing student data for ${doc.id}: $e");
              return null; // Skip invalid entries
            }
          })
          .whereType<StudentModel>()
          .toList(); // Removes any null values

      return students;
    } catch (e) {
      print("Error loading students by subject: $e");
      return [];
    }
  }

  Future<void> assignStudentToSubject(String studentId, String subject) async {
    try {
      DocumentReference studentRef =
          _firestore.collection('students').doc(studentId);
      await studentRef.update({
        'assigned_subjects': FieldValue.arrayUnion([subject])
      });
      print("Student $studentId assigned to subject $subject successfully");
      notifyListeners();
    } catch (e) {
      print("Error assigning student to subject: $e");
    }
  }


}
