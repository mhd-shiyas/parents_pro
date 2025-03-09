import 'package:flutter/material.dart';
import 'package:parent_pro/auth/screens/user_selection_screen.dart';
import 'package:parent_pro/dashboard/home/screens/home_screen.dart';
import 'package:parent_pro/teacher/screens/teacher_home_screen.dart';
import 'package:provider/provider.dart';

import '../auth/controller/auth_controller.dart';
import '../constants/color_constants.dart';
import '../teacher/controller/teacher_auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => navigateToNextScreen(context));
  }

  // Future<void> navigateToNextScreen(BuildContext context) async {
  //   final authProvider =
  //       Provider.of<AuthenticationController>(context, listen: false);

  //   await Future.delayed(const Duration(seconds: 2));

  //   if (authProvider.isSignedIn) {
  //     String? userType = await authProvider.getUserType();

  //     if (userType == 'Teacher') {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => TeacherDashboard(
  //               teacherId: authProvider.auth.currentUser?.uid ?? ''),
  //         ),
  //       );
  //     } else if (userType == 'Parent') {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => HomeScreen(),
  //         ),
  //       );
  //     } else {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => UserSelectionScreen(),
  //         ),
  //       );
  //     }
  //   } else {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => UserSelectionScreen()),
  //     );
  //   }
  // }

  Future<void> navigateToNextScreen(context) async {
    final teacherAuthProvider =
        Provider.of<TeacherAuthController>(context, listen: false);
    final studentAuthProvider =
        Provider.of<AuthenticationController>(context, listen: false);

    await Future.delayed(const Duration(seconds: 1));

    if (teacherAuthProvider.isSignedIn) {
      // Redirect to Teacher Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TeacherDashboard(teacherId: teacherAuthProvider.uid)),
      );
    } else if (studentAuthProvider.isSignedIn) {
      // Redirect to Student Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // No user is logged in, go to selection screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Image.asset(
            "assets/icons/logoinwhite.png",
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:parent_pro/auth/screens/user_selection_screen.dart';
// import 'package:provider/provider.dart';

// import '../auth/controller/auth_controller.dart';
// import '../constants/color_constants.dart';


// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => navigatetonNextScreen(context));
//   }

//   navigatetonNextScreen(context) async {
//     final authProvider =
//         Provider.of<AuthenticationController>(context, listen: false);
//     await Future.delayed(const Duration(seconds: 2), () {});
//     authProvider.isSignedIn == true
//         ? Navigator.push(
//             context, MaterialPageRoute(builder: (context) => HomeScreen()))
//         :
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => UserSelectionScreen()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstants.primaryColor,
//       body: Center(
//         child: SizedBox(
//           height: 300,
//           width: 300,
//           child: Image.asset(
//             "assets/icons/logoinwhite.png",
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
