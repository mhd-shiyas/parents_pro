import 'package:flutter/material.dart';
import 'package:parent_pro/teacher/model/student_model.dart';

import '../../parent/model/user_model.dart';
import '../repository/user_repository.dart';

class UserController with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isloading => _isLoading;

  Future<void> fetchUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    _user = await _userRepository.getUserById(userId);
    print(userId);

    _isLoading = false;
    notifyListeners();
  }
}
