import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch the details of the logged-in teacher
  Future<Map<String, dynamic>?> getTeacherDetails(String teacherId) async {
    try {
      DocumentSnapshot teacherDoc = await _firestore.collection('teachers').doc(teacherId).get();

      if (teacherDoc.exists) {
        return teacherDoc.data() as Map<String, dynamic>;
      } else {
        return null; // Return null if teacher not found
      }
    } catch (e) {
      throw Exception('Failed to fetch teacher details: $e');
    }
  }
}
