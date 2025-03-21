import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parent_pro/teacher/model/student_model.dart';


class UserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Future<UserModel?> getUser(String studentId) async {
  //   final doc = await FirebaseFirestore.instance
  //       .collection('students')
  //       .doc(studentId)
  //       .get();
  //   if (doc.exists) {
  //     return UserModel.fromMap(doc.data()!);
  //   }
  //   return null;
  // }

  Future<StudentModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firebaseFirestore.collection('students').doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return StudentModel.fromMap(snapshot.data()!);
      }
      print("repost $userId");
    } catch (e) {
      print("Error fetching user: $e");
    }
    return null;
  }

  // Fetch the details of the logged-in teacher
  Future<Map<String, dynamic>?> getStudentsDetails(String teacherId) async {
    try {
      DocumentSnapshot teacherDoc =
          await _firebaseFirestore.collection('teachers').doc(teacherId).get();

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
