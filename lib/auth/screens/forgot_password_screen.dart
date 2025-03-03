import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  // Future<void> _resetPassword() async {
  //   String email = _emailController.text.trim();
  //   String newPassword = _passwordController.text.trim();

  //   bool emailExists = await _authRepository.checkIfEmailExists(email);
  //   if (!emailExists) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Email not found!")),
  //     );
  //     return;
  //   }

  //   bool success = await _authRepository.resetPassword(email, newPassword);
  //   if (success) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Password reset successfully!")),
  //     );
  //     Navigator.pop(context); // Redirect to login
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to reset password!")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Enter your email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Enter new password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:(){},
              child: Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
