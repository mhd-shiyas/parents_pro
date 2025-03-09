import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsAttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchStudentAttendance(String studentId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('students').doc(studentId).get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['attendance'] ?? {};
      }
      return {};
    } catch (e) {
      print("Error fetching attendance: $e");
      return {};
    }
  }
}
