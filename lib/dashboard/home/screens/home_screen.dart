import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:parent_pro/auth/controller/department_details_controller.dart';
import 'package:parent_pro/constants/color_constants.dart';
import 'package:parent_pro/dashboard/fees/screens/fees_screen.dart';
import 'package:parent_pro/dashboard/profile/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../auth/controller/user_controller.dart';
import '../../assessment/screen/assessment_screen.dart';
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

    Provider.of<DepartmentDetailsController>(context, listen: false)
        .loadDepartmentTeachers(userController.user?.department ?? '');
    print("user department is  ${userController.user?.department ?? 'BCA'}");

    await userController.fetchUser(user?.uid ?? '');

    if (userController.user != null) {
      //  DateTime today = DateTime.now();

      print(
          "Fetching Today's Attendance for Student ID: ${userController.user?.studentId}");

      Map<int, bool?> fetchedAttendance =
          await attendanceController.fetchTodaysAttendance(
        userController.user?.studentId ?? '',
      );

      print("Final Attendance Data for Home Screen: $fetchedAttendance");

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset("assets/icons/logo.png"),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentProfileScreen(),
                    )),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  color: ColorConstants.primaryColor,
                ),
              )),
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
                Color color =
                    Colors.grey.withOpacity(0.4); // Default (Not Marked)

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
                  ListView(
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
                  Consumer<DepartmentDetailsController>(
                    builder: (context, value, child) {
                      final teachersDetails = value.teachers;
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "DEPARTMENT",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              userDetails.user?.department ?? '',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 8,
                                ),
                                itemCount: teachersDetails.length,
                                itemBuilder: (context, index) => Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(2, 3),
                                        blurRadius: 10,
                                        color: Colors.grey.withOpacity(0.2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(2),
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                  width: 2,
                                                  color: ColorConstants
                                                      .primaryColor
                                                      .withOpacity(0.2),
                                                )),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.network(
                                                teachersDetails[index]
                                                        .photoUrl ??
                                                    '',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                teachersDetails[index].name ??
                                                    '',
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                teachersDetails[index].role ??
                                                    '',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: teachersDetails[index]
                                                          .phone ??
                                                      ''));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Phone Number copied to clipboard!'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            child: HugeIcon(
                                              icon:
                                                  HugeIcons.strokeRoundedCall02,
                                              color:
                                                  ColorConstants.primaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: teachersDetails[index]
                                                          .email ??
                                                      ''));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Email copied to clipboard!'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            child: HugeIcon(
                                              icon:
                                                  HugeIcons.strokeRoundedMail01,
                                              color:
                                                  ColorConstants.primaryColor,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceButton(String label, Color color) {
    return Container(
      height: 45,
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
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(12),
        height: 50,
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
