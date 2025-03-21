import 'package:flutter/material.dart';
import 'package:parent_pro/teacher/model/teacher_model.dart';


import '../repository/deparment_details_repository.dart';


class DepartmentDetailsController with ChangeNotifier {
  final DepartmentDetailsRepository _repository = DepartmentDetailsRepository();
  List<Teacher> _teachers = [];
  List<Teacher> get teachers => _teachers;

  
  Future<void> loadDepartmentTeachers(String department) async {
    try {
      _teachers = await _repository.fetchDepartmentTeachers(department);
      notifyListeners();
    } catch (e) {
      print("Error loading teachers: $e");
    }
  }


 
}
