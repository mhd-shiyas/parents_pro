import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parent_pro/auth/controller/auth_controller.dart';
import 'package:parent_pro/auth/controller/user_controller.dart';
import 'package:parent_pro/firebase_options.dart';
import 'package:parent_pro/splash/splash_screen.dart';
import 'package:parent_pro/teacher/controller/assessment_controller.dart';
import 'package:parent_pro/teacher/controller/assign_period_controller.dart';
import 'package:parent_pro/teacher/controller/attendance_controller.dart';
import 'package:parent_pro/teacher/controller/students_controller.dart';
import 'package:parent_pro/teacher/controller/teacher_auth_controller.dart';
import 'package:parent_pro/teacher/controller/teacher_controller.dart';
import 'package:provider/provider.dart';

import 'auth/controller/department_details_controller.dart';
import 'auth/controller/fees_controller.dart';
import 'auth/controller/student_assessment_controller.dart';
import 'dashboard/attendance/controller/students_attendance_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthenticationController(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserController(),
        ),
        ChangeNotifierProvider(
          create: (context) => TeacherController(),
        ),
        ChangeNotifierProvider(
          create: (context) => TeacherAuthController(context),
        ),
        ChangeNotifierProvider(
          create: (context) => StudentController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AssignPeriodController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AttendanceController(),
        ),
        ChangeNotifierProvider(
          create: (context) => StudentsAttendanceController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AssessmentController(),
        ),
        ChangeNotifierProvider(
          create: (context) => StudentAssessmentController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FeesController(),
        ),
        ChangeNotifierProvider(
          create: (context) => DepartmentDetailsController(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
