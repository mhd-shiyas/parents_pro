import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:parent_pro/auth/screens/teacher_signup_screen.dart';
import 'package:parent_pro/dashboard/home/screens/home_screen.dart';
import 'package:parent_pro/teacher/screens/teacher_home_screen.dart';
import 'package:parent_pro/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../constants/color_constants.dart';
import '../../widgets/custom_textfield.dart';
import '../controller/teacher_auth_controller.dart';

class TeacherLoginScreen extends StatefulWidget {
  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final authProvider =
        Provider.of<TeacherAuthController>(context, listen: false);
    final FirebaseAuth user = FirebaseAuth.instance;
    setState(() => _isLoading = true);

    try {
      await authProvider.loginWithEmailPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context,
          onSuccess: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TeacherDashboard(
                    teacherId: user.currentUser!.uid,
                  ),
                ));
          });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<TeacherAuthController>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Teacher Login',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ColorConstants.primaryColor,
        ),
      )),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello!',
              style: GoogleFonts.inter(
                fontSize: 35,
                fontWeight: FontWeight.w900,
                color: ColorConstants.primaryColor,
              ),
            ),
            Text(
              'Enter your credentials to log in',
              style: GoogleFonts.poppins(
                fontSize: 17,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextfield(
              label: "Email",
              hint: "Enter your email",
              controller: emailController,
              prefix: HugeIcon(
                icon: HugeIcons.strokeRoundedMail02,
                color: ColorConstants.primaryColor,
              ),
            ),
            CustomTextfield(
                label: "Password",
                hint: "Enter your password",
                controller: passwordController,
                prefix: HugeIcon(
                  icon: HugeIcons.strokeRoundedSquareLockPassword,
                  color: ColorConstants.primaryColor,
                )),
            SizedBox(height: 20),
            authController.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.primaryColor,
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: CustomButton(
                      title: "Login",
                      onTap: _login,
                    )),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't Have an Account? "),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeacherSignUpScreen())),
                  child: const Text(
                    'Sign up.',
                    style: TextStyle(
                      color: ColorConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:parent_pro/auth/screens/forgot_password_screen.dart';
// import 'package:parent_pro/dashboard/home/screens/home_screen.dart';
// import 'package:provider/provider.dart';

// import '../../constants/color_constants.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';
// import '../controller/auth_controller.dart';
// import '../repository/auth_repository.dart';

// class TeacherLoginScreen extends StatefulWidget {
//   @override
//   State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
// }

// class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   bool _isLoading = false;
//   String? _errorMessage;
//   final AuthRepository _authRepository = AuthRepository();

//   void _login() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     bool success = await _authRepository.login(
//       emailController.text.trim(),
//       passwordController.text.trim(),
//     );

//     setState(() {
//       _isLoading = false;
//     });

//     if (success) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     } else {
//       setState(() {
//         _errorMessage = "Invalid email or password";
//       });
//     }
//   }

//   // void _login(BuildContext context) async {
//   //   final authController =
//   //       Provider.of<AuthenticationProvider>(context, listen: false);

//   //   String? errorMessage = await authController.loginUser(
//   //     emailController.text.trim(),
//   //     passwordController.text.trim(),
//   //   );

//   //   if (errorMessage != null) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text(errorMessage)),
//   //     );
//   //   } else {
//   //     // Navigate to home screen on success
//   //     Navigator.pushReplacement(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => HomeScreen(),
//   //       ),
//   //     );
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     emailController.selection = TextSelection.fromPosition(
//         TextPosition(offset: emailController.text.length));
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: ColorConstants.primaryColor,
//           image: DecorationImage(
//             image: AssetImage("assets/images/login_bg.png"),
//             fit: BoxFit.cover,
//             opacity: 0.3,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 80),
//             Padding(
//               padding: const EdgeInsets.all(20.0).copyWith(bottom: 0),
//               child: Text(
//                 'Hello!',
//                 style: GoogleFonts.poppins(
//                   fontSize: 35,
//                   fontWeight: FontWeight.w900,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0).copyWith(top: 0),
//               child: Text(
//                 'Stay updated with your students college details',
//                 style: GoogleFonts.poppins(
//                   fontSize: 17,
//                   color: Colors.white70,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//             Expanded(
//               child: Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Login',
//                       style: GoogleFonts.inter(
//                         fontSize: 25,
//                         fontWeight: FontWeight.w900,
//                         color: ColorConstants.primaryColor,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     CustomTextfield(
//                       label: "Email",
//                       hint: "Enter your email",
//                       controller: emailController,
//                       prefix: HugeIcon(
//                         icon: HugeIcons.strokeRoundedMail02,
//                         color: ColorConstants.primaryColor,
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     CustomTextfield(
//                         label: "Password",
//                         hint: "Enter your password",
//                         controller: passwordController,
//                         prefix: HugeIcon(
//                           icon: HugeIcons.strokeRoundedSquareLockPassword,
//                           color: ColorConstants.primaryColor,
//                         )),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ForgotPasswordScreen(),
//                               ));
//                         },
//                         child: Text(
//                           'Forgot Password?',
//                           style: GoogleFonts.poppins(
//                             color: ColorConstants.primaryColor.withOpacity(0.9),
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     if (_errorMessage != null)
//                       Text(_errorMessage!, style: TextStyle(color: Colors.red)),
//                     ElevatedButton(
//                       onPressed: _isLoading ? null : _login,
//                       child: _isLoading
//                           ? CircularProgressIndicator()
//                           : Text("Login"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
