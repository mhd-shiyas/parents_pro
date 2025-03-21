import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parent_pro/dashboard/home/screens/home_screen.dart';
import 'package:parent_pro/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/auth_repository.dart';
import '../screens/user_selection_screen.dart';

class AuthenticationController with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uid;
  String get uid => _uid!;

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

  Future<void> registerTeacher(
      {required String id,
      required String name,
      required String email,
      required String phone,
      required String password,
      required String department,
      required String role,
      required File? image,
      required Function onSuccess}) async {
    await _authRepository.requestTeacherApproval(
        id, name, email, phone, password, image, department, role);
    onSuccess();
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _uid = auth.currentUser?.uid;
      onSuccess();

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
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

  // Future<void> signOut() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   await _firebaseAuth.signOut();
  //   _isSignedIn = false;
  //   await sharedPreferences.remove("is_signedin");
  //   notifyListeners();
  // }
}
