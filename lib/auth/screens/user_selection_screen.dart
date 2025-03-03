import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parent_pro/auth/screens/login_screen.dart';
import 'package:parent_pro/constants/color_constants.dart';
import 'package:parent_pro/widgets/custom_button.dart';

import '../../teacher/screens/teacher_login_screen.dart';

class UserSelectionScreen extends StatefulWidget {
  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  String? selectedUserType;
  final List<String> userTypes = ['Teacher', 'Parent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0).copyWith(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Your User Type',
                style: GoogleFonts.inter(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Choose whether you are a Teacher or a Parent',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 16),
            Container(
              // padding: EdgeInsets.all(6).copyWith(left: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 2,
                    color: ColorConstants.primaryColor.withOpacity(0.4),
                  )),
              child: ButtonTheme(
                alignedDropdown: true,
                // padding: EdgeInsets.only(
                //     left: 0.0, right: 0.0, top: 100, bottom: 0.0),
                child: DropdownButtonFormField<String>(
                  value: selectedUserType,
                  hint: Text(
                    'Select User Type',
                    style: GoogleFonts.inter(),
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10)),
                  borderRadius: BorderRadius.circular(16),
                  padding: EdgeInsets.all(6).copyWith(left: 0),
                  items: userTypes.map((String userType) {
                    return DropdownMenuItem<String>(
                      value: userType,
                      child: Text(userType),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUserType = newValue;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text('Proceed to the next step based on your selection',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
            SizedBox(height: 10),
            SizedBox(
                height: 60,
                width: double.infinity,
                child: CustomButton(
                  bgColor: ColorConstants.primaryColor,
                  title: "Continue",
                  onTap: selectedUserType == null
                      ? () {}
                      : () {
                          if (selectedUserType == 'Teacher') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TeacherLoginScreen()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginScreen(userType: 'Parent')));
                          }
                        },
                ))
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:parent_pro/constants/color_constants.dart';
// import 'package:parent_pro/widgets/custom_button.dart';

// import 'login_screen.dart';
// import 'teacher_signup_screen.dart';

// class UserSelectionScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text('Select User Type')),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Select Your User Type',
//                   style: GoogleFonts.inter(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w900,
//                   )),
//               SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 height: 60,
//                 child: CustomButton(
//                   title: "Teacher",
//                   bgColor: Colors.white,
//                   textColor: ColorConstants.primaryColor,
//                   onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => LoginScreen(
//                                 userType: "Teacher",
//                               ))),
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 height: 60,
//                 child: CustomButton(
//                   title: "Parent",
//                   bgColor: Colors.white,
//                   textColor: ColorConstants.primaryColor,
//                   onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => LoginScreen(
//                                 userType: "Parent",
//                               ))),
//                 ),
//               ),

//               // ElevatedButton(
//               //   onPressed: () => Navigator.push(
//               //       context,
//               //       MaterialPageRoute(
//               //           builder: (context) => LoginScreen(userType: 'parent'))),
//               //   child: Text('Parent Login'),
//               // ),
//               // ElevatedButton(
//               //   onPressed: () => Navigator.push(
//               //       context,
//               //       MaterialPageRoute(
//               //           builder: (context) => LoginScreen(userType: 'teacher'))),
//               //   child: Text('Teacher Login'),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
