import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ParentAuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  String? get currentUserId {
    return _auth.currentUser?.uid;
  }
}
