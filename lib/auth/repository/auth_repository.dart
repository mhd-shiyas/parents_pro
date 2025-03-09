import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> requestTeacherApproval(
    String id,
    String name,
    String email,
    String phone,
    String password,
    File? image,
    String department,
    String role,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String imageUrl = '';
      if (image != null) {
        TaskSnapshot uploadTask = await _storage
            .ref('teacher_profiles/${userCredential.user!.uid}')
            .putFile(image);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }
      await _firestore
          .collection('teacher_requests')
          .doc(userCredential.user!.uid)
          .set({
        "id": userCredential.user!.uid,
        'name': name,
        'department': department,
        'role': role,
        'email': email,
        'phone': phone,
        'imageUrl': imageUrl,
        'status': 'pending',
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot userDoc = await _firestore
          .collection('students')
          .doc(userCredential.user?.uid)
          .get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
    } catch (e) {
      print('Login Error: $e');
    }
  }
}
