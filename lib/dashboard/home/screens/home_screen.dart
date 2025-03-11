import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:parent_pro/constants/color_constants.dart';
import 'package:parent_pro/dashboard/fees/screens/fees_screen.dart';
import 'package:provider/provider.dart';

import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/user_controller.dart';
import '../../assessment/screen/assessment_screen.dart';
import '../../assignment/screens/assignment_screen.dart';
import '../../attendance/controller/students_attendance_controller.dart';
import '../../attendance/screens/attendance_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  TabController? tabbarController;
  int currentIndex = 0;
  Map<int, bool?> attendanceStatus = {}; // Store attendance status

  @override
  void initState() {
    super.initState();
    tabbarController = TabController(length: 2, vsync: this);
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    final userController = Provider.of<UserController>(context, listen: false);
    final attendanceController =
        Provider.of<StudentsAttendanceController>(context, listen: false);

    await userController.fetchUser(user!.uid);

    if (userController.user != null) {
      DateTime today = DateTime.now();

      print(
          "📢 Fetching Today's Attendance for Student ID: ${userController.user?.studentId}");

      Map<int, bool?> fetchedAttendance =
          await attendanceController.fetchTodaysAttendance(
        userController.user?.studentId ?? '',
      );

      print("🎯 Final Attendance Data for Home Screen: $fetchedAttendance");

      setState(() {
        attendanceStatus = fetchedAttendance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserController>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset("assets/icons/logo.png"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SvgPicture.asset(
              "assets/icons/notificationIcon.svg",
              height: 20,
              width: 20,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                  onTap: () {
                    Provider.of<AuthenticationController>(context,
                            listen: false)
                        .logout(context);
                  },
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedLogout01,
                    color: ColorConstants.primaryColor,
                  ))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Consumer<UserController>(
              builder: (context, value, child) {
                return Container(
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
                            radius: 25,
                            backgroundColor: Colors.grey[400],
                            child: const Icon(Icons.person,
                                size: 30, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value.user?.studentName?.toUpperCase() ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Roll No: ${value.user?.rollNumber ?? '0'}",
                                style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Dep: ${value.user?.department ?? ''}",
                                style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Attendance Section
            Text(
              "Today's Attendance",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                int period = index + 1;
                Color color = Colors.grey; // Default (Not Marked)

                if (attendanceStatus.containsKey(period)) {
                  color = attendanceStatus[period] == true
                      ? Colors.green
                      : Colors.red;
                }

                return _buildAttendanceButton('${period}hr', color);
              }),
            ),

            const SizedBox(height: 24),

            // Tab Section
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: ColorConstants.primaryColor.withOpacity(0.01),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConstants.primaryColor,
                ),
                controller: tabbarController,
                padding: const EdgeInsets.all(8)
                    .copyWith(top: 10, bottom: 10, left: 0),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                labelStyle: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                indicatorColor: Colors.blue,
                tabs: const [
                  SizedBox(width: 150, child: Tab(text: "Student")),
                  SizedBox(width: 200, child: Tab(text: "Department")),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grid Section
            Expanded(
              child: TabBarView(
                controller: tabbarController,
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildGridItem(
                          'Assessment',
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentAssessmentsScreen(
                                  studentId: user?.uid ?? '',
                                ),
                              ))),
                      _buildGridItem(
                        'Attendance',
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttendanceScreen(
                                studentId: user?.uid ?? '',
                              ),
                            )),
                      ),
                      _buildGridItem(
                        'Fees',
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeesScreen(
                                studentId: user?.uid ?? '',
                              ),
                            )),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Department:",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Bachelor of Computer Application (BCA)",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
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
                      icon: HugeIcons.strokeRoundedCreditCard,
                      color: Colors.white,
                    ),
                    label: 'Students'),
                BottomNavigationBarItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedGoogleSheet,
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => StudentListScreen(
                    //       department: department,
                    //     ),
                    //   ),
                    // );
                    break;
                  case 2:
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => TeacherAssignedPeriodsScreen(
                    //       teacherId: id,
                    //     ),
                    //   ),
                    // );
                    break;
                  case 3:
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => TeacherProfileScreen(
                    //       teacherDetails: teacherData,
                    //     ),
                    //   ),
                    // );//
                    break;
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceButton(String label, Color color) {
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildGridItem(
    String label,
    Function()? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: ColorConstants.primaryColor.withOpacity(0.8),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: ColorConstants.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:parent_pro/constants/color_constants.dart';
// import 'package:provider/provider.dart';

// import '../../../auth/controller/auth_controller.dart';
// import '../../../auth/controller/user_controller.dart';
// import '../../../auth/repository/auth_repository.dart';
// import '../../assignment/screens/assignment_screen.dart';
// import '../../attendance/screens/attendance_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   final user = FirebaseAuth.instance.currentUser;

//   @override
//   void initState() {
//     super.initState();
//     tabbarController = TabController(length: 2, vsync: this);

//     fetchInitialData();
//   }

//   Future<void> fetchInitialData() async {
//     Provider.of<UserController>(context, listen: false).fetchUser(user!.uid);
//   }

//   final AuthRepository _authRepository = AuthRepository();

//   // _logout(BuildContext context) async {
//   //   // await _authRepository.logout();
//   //   // Navigator.pushAndRemoveUntil(
//   //   //   context,
//   //   //   MaterialPageRoute(builder: (context) => LoginScreen()),
//   //   //   (route) => false, // Remove all previous routes
//   //   // );
//   // }

//   TabController? tabbarController;
//   int currentIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       drawer: Drawer(),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.menu, color: Colors.black),
//           onPressed: () => Scaffold.of(context).openDrawer(),
//         ),
//         title: SizedBox(
//           height: 100,
//           width: 100,
//           child: Image.asset(
//             "assets/icons/logo.png",
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: SvgPicture.asset(
//               "assets/icons/notificationIcon.svg",
//               height: 20,
//               width: 20,
//             ),
//           ),
//           Padding(
//               padding: const EdgeInsets.only(right: 12.0),
//               child: InkWell(
//                   onTap: () {
//                     Provider.of<AuthenticationController>(context)
//                         .logout(context);
//                   },
//                   child: HugeIcon(
//                     icon: HugeIcons.strokeRoundedLogout01,
//                     color: ColorConstants.primaryColor,
//                   ))),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Profile Section
//             Consumer<UserController>(
//               builder: (context, value, child) {
//                 return Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           offset: Offset(2, 3),
//                           blurRadius: 10,
//                           color: Colors.grey.withOpacity(0.2),
//                         )
//                       ]),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 25,
//                             backgroundColor: Colors.grey[400],
//                             child: const Icon(Icons.person,
//                                 size: 30, color: Colors.white),
//                           ),
//                           const SizedBox(width: 16),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 value.user?.studentName?.toUpperCase() ?? '',
//                                 style: GoogleFonts.montserrat(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 "Roll No: ${value.user?.rollNumber ?? '0'}",
//                                 style: GoogleFonts.montserrat(
//                                   color: Colors.grey,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               Text(
//                                 "Dep: ${value.user?.department ?? ''}",
//                                 style: GoogleFonts.montserrat(
//                                   color: Colors.grey,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       // InkWell(
//                       //   onTap: _logout(context),
//                       //   child: const Icon(
//                       //     Icons.logout_outlined,
//                       //     size: 20,
//                       //   ),
//                       // )
//                     ],
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 24),

//             // Attendance Section
//             Text(
//               "Today's Attendance",
//               style: GoogleFonts.montserrat(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildAttendanceButton('1hr', Colors.green),
//                 _buildAttendanceButton('2hr', Colors.red),
//                 _buildAttendanceButton('3hr', Colors.yellow),
//                 _buildAttendanceButton('4hr', Colors.grey),
//                 _buildAttendanceButton('5hr', Colors.grey),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Tab Section
//             Container(
//               height: 60,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: ColorConstants.primaryColor.withOpacity(0.01),
//               ),
//               child: TabBar(
//                 dividerColor: Colors.transparent,
//                 onTap: (index) {
//                   setState(() {
//                     currentIndex = index;
//                   });
//                 },
//                 indicator: BoxDecoration(
//                   borderRadius: BorderRadius.circular(
//                     8,
//                   ),
//                   color: ColorConstants.primaryColor,
//                 ),
//                 controller: tabbarController,
//                 padding: const EdgeInsets.all(8)
//                     .copyWith(top: 10, bottom: 10, left: 0),
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.grey,
//                 labelStyle: GoogleFonts.montserrat(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 indicatorColor: Colors.blue,
//                 tabs: const [
//                   SizedBox(width: 150, child: Tab(text: "Student")),
//                   SizedBox(width: 200, child: Tab(text: "Department")),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Grid Sectioc
//             Expanded(
//               child: TabBarView(
//                 controller: tabbarController,
//                 children: [
//                   GridView.count(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     children: [
//                       _buildGridItem(
//                           'Assessment',
//                           Colors.cyan,
//                           () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => AssignmentScreen(),
//                               ))),
//                       _buildGridItem(
//                         'Attendance',
//                         Colors.pink,
//                         () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AttendanceScreen(),
//                             )),
//                       ),
//                       _buildGridItem(
//                         'Departments',
//                         Colors.purple,
//                         () {},
//                       ),
//                       _buildGridItem(
//                         'Grievance',
//                         Colors.blue,
//                         () {},
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Department:",
//                         style: GoogleFonts.montserrat(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "Bachelor of Computer Application (BCA)",
//                         style: GoogleFonts.montserrat(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.credit_card),
//             label: 'Payments',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Schedule',
//           ),
//         ],
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//       ),
//     );
//   }

//   Widget _buildAttendanceButton(String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       height: 52,
//       width: 52,
//       decoration: BoxDecoration(
//         // color: color,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: color,
//           width: 2,
//           strokeAlign: BorderSide.strokeAlignOutside,
//         ),
//       ),
//       child: Center(
//         child: Text(
//           label,
//           style: TextStyle(
//               color: color, fontWeight: FontWeight.w900, fontSize: 10),
//         ),
//       ),
//     );
//   }

//   Widget _buildTabButton(String label, bool isActive) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isActive ? Colors.black : Colors.grey[300],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           label,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: isActive ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGridItem(
//     String label,
//     Color color,
//     Function()? onTap,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
