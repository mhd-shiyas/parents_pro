import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parent_pro/teacher/repository/teacher_auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentAuthController with ChangeNotifier {
  final TeacherAuthRepository _authRepository = TeacherAuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  String? _uid;
  String get uid => _uid!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AuthenticationProvider() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    _isSignedIn = data.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // Future<void> registerTeacher(
  //     {required String id,
  //     required String name,
  //     required String email,
  //     required String phone,
  //     required String password,
  //     required String department,
  //     required File? image,
  //     required Function onSuccess}) async {
  //   await _authRepository.requestTeacherApproval(
  //       id, name, email, phone, password, image, department);
  //   onSuccess();
  // }

  // Future<void> loginWithEmailPassword({
  //   required String email,
  //   required String password,
  //   required BuildContext context,
  //   required Function onSuccess,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     await _firebaseAuth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     _uid = _firebaseAuth.currentUser?.uid;
  //     DocumentSnapshot userDoc =
  //         await _firebaseFirestore.collection('teachers').doc(_uid).get();

  //     if (userDoc.exists && userDoc['approval'] == true) {
  //       notifyListeners();
  //     } else {
  //       throw Exception(
  //           'Your account is pending approvel or has been rejected.');
  //     }
  //     onSuccess();

  //     notifyListeners();
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message.toString());
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}

