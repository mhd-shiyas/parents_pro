import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/student_model.dart';

class StudentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<StudentModel>> fetchStudents(String department) async {
    try {
      print("Fetching students for department: $department");
      QuerySnapshot snapshot = await _firestore
          .collection('students')
          .where('department', isEqualTo: department)
          .get();
      print("Fetched \${snapshot.docs.length} students");
      return snapshot.docs
          .map((doc) => StudentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching students: $e");
      return [];
    }
  }

  Future<void> addStudent(StudentModel student, String password) async {
    try {
      print("Creating student user in Firebase Auth");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: student.email ?? '', password: password);
      
      String studentId = userCredential.user!.uid;
      student.studentId = studentId;
      await _firestore.collection('students').doc(studentId).set(student.toMap());
      print("Student added with ID: $studentId");
    } catch (e) {
      print("Error adding student: $e");
    }
  }

  Future<void> updateStudent(String studentId, Map<String, dynamic> updatedData) async {
    try {
      print("Updating student ID: $studentId with data: $updatedData");
      await _firestore.collection('students').doc(studentId).update(updatedData);
      print("Student updated successfully");
    } catch (e) {
      print("Error updating student: $e");
    }
  }
}