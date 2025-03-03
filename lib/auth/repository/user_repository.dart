import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parent_pro/teacher/model/student_model.dart';

import '../../parent/model/user_model.dart';

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

  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firebaseFirestore.collection('students').doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data()!);
      }
      print("repost $userId");
    } catch (e) {
      print("Error fetching user: $e");
    }
    return null;
  }
}
