import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/student_model.dart';

class StudentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<StudentModel>> fetchStudents(String department) async {
    QuerySnapshot snapshot = await _firestore
        .collection('students')
        .where('department', isEqualTo: department)
        .get();

    return snapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addStudent(StudentModel student, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: student.email ?? '', password: password);

    String studentId = userCredential.user!.uid;
    student.studentId = studentId;
    await _firestore.collection('students').doc(studentId).set(student.toMap());
  }
}
