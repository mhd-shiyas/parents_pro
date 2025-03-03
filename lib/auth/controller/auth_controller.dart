import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parent_pro/dashboard/home/screens/home_screen.dart';
import 'package:parent_pro/teacher/screens/teacher_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/auth_repository.dart';
import '../screens/user_selection_screen.dart';

class AuthenticationController with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  AuthenticationController() {
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

  Future<String?> getUserType() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    return s.getString("user_type");
  }

  Future<void> registerTeacher(
      {required String id,
      required String name,
      required String email,
      required String phone,
      required String password,
      required String department,
      required File? image,
      required Function onSuccess}) async {
    await _authRepository.requestTeacherApproval(
        id, name, email, phone, password, image, department);
    onSuccess();
  }

  Future<void> login(String userType, String email, String password,
      BuildContext context) async {
    await _authRepository.login(email, password);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
  }

  /// **Logout Function**
  Future<void> logout(BuildContext context) async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await auth.signOut(); // Firebase Sign Out
    await s.clear(); // Clear stored login state
    _isSignedIn = false;
    notifyListeners();

    // Redirect user to login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UserSelectionScreen()),
      (route) => false,
    );
  }
}
