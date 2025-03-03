import 'package:flutter/material.dart';
import 'package:parent_pro/teacher/model/student_model.dart';
import 'package:parent_pro/teacher/model/teacher_model.dart';

import '../repository/students_repository.dart';

class StudentController with ChangeNotifier {
  final StudentRepository _repository = StudentRepository();
  List<StudentModel> _students = [];
  List<StudentModel> get students => _students;

  Future<void> loadStudents(String department) async {
    _students = await _repository.fetchStudents(department);
    notifyListeners();
  }

  Future<void> addStudent(StudentModel student, String password) async {
    await _repository.addStudent(student, password);
    loadStudents(student.department!); // Reload students after adding a new one
  }
}
