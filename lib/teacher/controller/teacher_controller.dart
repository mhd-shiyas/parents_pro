import 'package:flutter/material.dart';
import '../repository/teacher_repository.dart';

class TeacherController with ChangeNotifier {
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
}
