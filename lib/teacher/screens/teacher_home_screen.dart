import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:parent_pro/teacher/screens/assigned_periods_screen.dart';
import 'package:parent_pro/teacher/screens/student_list_screen.dart';
import 'package:parent_pro/teacher/screens/assign_periods_screen.dart';
import 'package:provider/provider.dart';
import '../../constants/color_constants.dart';
import '../controller/teacher_controller.dart';
import 'teacher_profile_screen.dart';

class TeacherDashboard extends StatefulWidget {
  final String teacherId; // Logged-in teacher's ID

  TeacherDashboard({required this.teacherId});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<TeacherController>(context, listen: false)
        .fetchTeacherDetails(widget.teacherId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherController>(
      builder: (context, teacherController, child) {
        if (teacherController.isLoading) {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(
                  'Dashboard',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primaryColor,
                  ),
                )),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (teacherController.teacherData == null) {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(
                  'Dashboard',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primaryColor,
                  ),
                )),
            body: Center(child: Text('Teacher data not found')),
          );
        }

        var teacherData = teacherController.teacherData!;
        String id = teacherData["id"] ?? '';
        String name = teacherData['name'] ?? 'Unknown';
        String department = teacherData['department'] ?? 'Not specified';
        String role = teacherData['role'] ?? 'Not specified';
        String imageUrl = teacherData['imageUrl'] ?? '';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text(
                'Dashboard',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.primaryColor,
                ),
              )),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TeacherProfileScreen(teacherDetails: teacherData),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2, 3),
                            blurRadius: 10,
                            color: Colors.grey.withOpacity(0.2),
                          )
                        ]),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: ColorConstants.primaryColor,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  backgroundImage: imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : null,
                                  child: imageUrl.isEmpty
                                      ? Icon(Icons.person)
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(department,
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.grey))
                                ],
                              ),
                            ],
                          ),
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowRight01,
                            color: ColorConstants.primaryColor,
                          )
                        ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                role == "HOD"
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssignPeriodsScreen()),
                          );
                        },
                        child: Container(
                            height: 100,
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(2, 3),
                                    blurRadius: 10,
                                    color: Colors.grey.withOpacity(0.2),
                                  )
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Assign Teachers",
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.primaryColor,
                                  ),
                                ),
                                Text(
                                  "(Assign the Teachers to Periods)",
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.all(4.0).copyWith(bottom: 2),
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: ColorConstants.secondaryColor.withOpacity(0.3),
                    width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BottomNavigationBar(
                  elevation: 10,
                  //  unselectedItemColor: Colors.black38,
                  selectedItemColor: ColorConstants.primaryColor,
                  unselectedLabelStyle: GoogleFonts.montserrat(),
                  selectedLabelStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                  ),
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  currentIndex: 0,
                  backgroundColor: ColorConstants.primaryColor,

                  items: [
                    BottomNavigationBarItem(
                      backgroundColor: ColorConstants.primaryColor,
                      icon: Column(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedHome01,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedUserAdd01,
                          color: Colors.white,
                        ),
                        label: 'Students'),
                    BottomNavigationBarItem(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedAssignments,
                          color: Colors.white,
                        ),
                        label: 'Periods'),
                    BottomNavigationBarItem(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedUser,
                          color: Colors.white,
                        ),
                        label: 'Profile'),
                  ],
                  onTap: (index) {
                    switch (index) {
                      case 0: // Home

                        break;

                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentListScreen(
                              department: department,
                            ),
                          ),
                        );
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherAssignedPeriodsScreen(
                              teacherId: id,
                            ),
                          ),
                        );
                        break;
                      case 3:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherProfileScreen(
                              teacherDetails: teacherData,
                            ),
                          ),
                        );
                        break;
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:parent_pro/constants/color_constants.dart';
// import 'package:provider/provider.dart';
// import '../controller/teacher_controller.dart';

// class TeacherDashboard extends StatefulWidget {
//   final String userId;

//   TeacherDashboard({required this.userId});

//   @override
//   State<TeacherDashboard> createState() => _TeacherDashboardState();
// }

// class _TeacherDashboardState extends State<TeacherDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     fetchInitialData();
//   }

//   Future<void> fetchInitialData() async {
//     Provider.of<TeacherController>(context, listen: false)
//         .fetchTeacherDetails(widget.userId, context);
//   }

//   //final user = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           centerTitle: true,
//           automaticallyImplyLeading: false,
//           title: Text(
//             'Dashboard',
//             style: GoogleFonts.inter(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: ColorConstants.primaryColor,
//             ),
//           )),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Consumer<TeacherController>(
//               builder: (context, value, child) => InkWell(
//                 onTap: () {
//                   // Fetch teacher details when tapped and navigate to the profile screen
//                   TeacherController()
//                       .fetchTeacherDetails(widget.userId, context);
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           offset: Offset(2, 3),
//                           blurRadius: 10,
//                           color: Colors.grey.withOpacity(0.4),
//                         )
//                       ]),
//                   child: Row(
//                     children: [
//                        CircleAvatar(
//                                       radius: 22,
//                                       child: CircleAvatar(
//                                         radius: 20,
//                                         backgroundColor: Colors.white,
//                                         backgroundImage: value. !=
//                                                 null
//                                             ? NetworkImage(request['imageUrl'])
//                                             : AssetImage(
//                                                     'assets/images/profile.png')
//                                                 as ImageProvider,
//                                       ),
//                                     ),
//                       Text(
//                         'Click to view teacher details',
//                         style: TextStyle(color: Colors.white, fontSize: 22),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Tap here to see profile',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
