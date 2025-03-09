import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:parent_pro/common/custom_appbar.dart';

import 'package:provider/provider.dart';
import '../../constants/color_constants.dart';
import '../controller/attendance_controller.dart';
import '../controller/students_controller.dart';
import '../model/student_model.dart';
import 'subject_student_adding_screen.dart';

class AttendanceMarkingScreen extends StatefulWidget {
  final String subject;
  final String teacherId;
  final String paperCode;
  final int semester; // Receive semester

  const AttendanceMarkingScreen({
    super.key,
    required this.subject,
    required this.teacherId,
    required this.paperCode,
    required this.semester,
  });

  @override
  _AttendanceMarkingScreenState createState() =>
      _AttendanceMarkingScreenState();
}

class _AttendanceMarkingScreenState extends State<AttendanceMarkingScreen> {
  DateTime selectedDate = DateTime.now();
  int selectedPeriod = 1;
  Map<String, bool> attendanceStatus = {};
  List<StudentModel> students = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStudents();
      _loadAttendanceData();
    });
  }

  void _loadStudents() async {
    try {
      final loadedStudents =
          await Provider.of<StudentController>(context, listen: false)
              .loadStudentsBySubject(widget.subject);
      setState(() {
        students = loadedStudents;
      });
    } catch (error) {
      print("Error loading students: $error");
    }
  }

  void _loadAttendanceData() async {
    try {
      final attendanceController =
          Provider.of<AttendanceController>(context, listen: false);

      final data = await attendanceController.fetchAttendanceForDate(
        widget.subject, // Now correctly passing subject

        // widget.teacherId,
        widget.semester, // Now correctly passing semester
        selectedDate,
        selectedPeriod,
      );

      setState(() {
        attendanceStatus = data;
      });

      print("Loaded attendance: $attendanceStatus"); // Debugging log
    } catch (error) {
      print("Error loading attendance: $error");
    }
  }

  void _markAttendance(StudentModel student, bool isPresent) {
    Provider.of<AttendanceController>(context, listen: false).markAttendance(
      studentId: student.studentId!,
      date: selectedDate,
      period: selectedPeriod,
      subject: widget.subject,
      paperCode: widget.paperCode,
      isPresent: isPresent,
      semester:
          widget.semester, // Use semester from TeacherAssignedPeriodsScreen
    );
    setState(() {
      attendanceStatus[student.studentId!] = isPresent;
    });
  }

  void _showAttendancePopup(StudentModel student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Update Attendance for ${student.studentName}",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                _markAttendance(student, true);
                Navigator.pop(context);
              },
              child: Text(
                "Present",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                _markAttendance(student, false);
                Navigator.pop(context);
              },
              child: Text(
                "Absent",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddStudentsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StudentAddingToSubjectsScreen(subject: widget.subject),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Mark Attendance"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Select Date",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                  width: 2,
                                  color: ColorConstants.primaryColor
                                      .withOpacity(0.5)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                              });
                              _loadAttendanceData();
                            }
                          },
                          child: Text(
                            "${selectedDate.toLocal()}".split(' ')[0],
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(12).copyWith(top: 0, bottom: 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              width: 2,
                              color: ColorConstants.primaryColor
                                  .withOpacity(0.5))),
                      child: DropdownButton<int>(
                        value: selectedPeriod,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedPeriod = newValue!;
                          });
                          _loadAttendanceData();
                        },
                        items: List.generate(5, (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text(
                              "Period ${index + 1}",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.primaryColor,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? const Center(child: Text("No students available"))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      Color statusColor =
                          attendanceStatus.containsKey(student.studentId!)
                              ? (attendanceStatus[student.studentId!]!
                                  ? Colors.green
                                  : Colors.red)
                              : Colors.grey.withOpacity(0.5);
                      return GestureDetector(
                        onTap: () => _showAttendancePopup(student),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              student.rollNumber ?? "-",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: _navigateToAddStudentsScreen,
        child: Container(
          height: 60,
          width: 180,
          decoration: BoxDecoration(
              color: ColorConstants.primaryColor,
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIcon(
                  icon: HugeIcons.strokeRoundedAddTeam, color: Colors.white),
              SizedBox(
                width: 6,
              ),
              Text(
                "Add Students",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:parent_pro/teacher/screens/subject_student_adding_screen.dart';
// import 'package:provider/provider.dart';
// import '../controller/attendance_controller.dart';
// import '../controller/students_controller.dart';
// import '../model/student_model.dart';
// import 'package:parent_pro/constants/color_constants.dart';

// class AttendanceMarkingScreen extends StatefulWidget {
//   final String subject;
//   final String teacherId;
//   final String paperCode;

//   const AttendanceMarkingScreen(
//       {super.key,
//       required this.subject,
//       required this.teacherId,
//       required this.paperCode});

//   @override
//   _AttendanceMarkingScreenState createState() =>
//       _AttendanceMarkingScreenState();
// }

// class _AttendanceMarkingScreenState extends State<AttendanceMarkingScreen> {
//   DateTime selectedDate = DateTime.now();
//   int selectedPeriod = 1;
//   String? selectedDepartment;
//   int? selectedSemester;

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<StudentController>(context, listen: false)
//         .loadStudentsBySubject(widget.subject);
//   }

//   void _markAttendance(StudentModel student, bool isPresent) {
//     Provider.of<AttendanceController>(context, listen: false).markAttendance(
//       studentId: student.studentId!,
//       date: selectedDate,
//       period: selectedPeriod,
//       subject: widget.subject,
//       paperCode: widget.paperCode,
//       isPresent: isPresent,
//     );
//     setState(() {
//       student.attendance[selectedDate.toString()]?[selectedPeriod] = isPresent;
//     });
//   }

//   void _showAttendancePopup(StudentModel student) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Mark Attendance for ${student.studentName}"),
//         content: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               onPressed: () {
//                 _markAttendance(student, true);
//                 Navigator.pop(context);
//               },
//               child: Text("Present"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               onPressed: () {
//                 _markAttendance(student, false);
//                 Navigator.pop(context);
//               },
//               child: Text("Absent"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateToAddStudentsScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             SubjectsStudentsAddingScreen(subject: widget.subject),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Mark Attendance"),
//         backgroundColor: ColorConstants.primaryColor,
//         actions: [
//           // TextButton(
//           //   onPressed: _navigateToAddStudentsScreen,
//           //   child: Text("Add Students", style: TextStyle(color: Colors.white)),
//           // )
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Text("Select Date"),
//                 ElevatedButton(
//                   onPressed: () async {
//                     DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: selectedDate,
//                       firstDate: DateTime(2020),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null) {
//                       setState(() => selectedDate = picked);
//                     }
//                   },
//                   child: Text("${selectedDate.toLocal()}".split(' ')[0]),
//                 ),
//                 DropdownButton<int>(
//                   value: selectedPeriod,
//                   onChanged: (int? newValue) {
//                     setState(() {
//                       selectedPeriod = newValue!;
//                     });
//                   },
//                   items: List.generate(5, (index) {
//                     return DropdownMenuItem(
//                       value: index + 1,
//                       child: Text("Period ${index + 1}"),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Consumer<StudentController>(
//               builder: (context, studentController, child) {
//                 List<StudentModel> students = studentController.students
//                     .where((s) =>
//                         (selectedDepartment == null ||
//                             s.department == selectedDepartment) &&
//                         (selectedSemester == null ||
//                             s.currentSemester == selectedSemester))
//                     .toList();

//                 return students.isEmpty
//                     ? Center(child: Text("No students available"))
//                     : GridView.builder(
//                         padding: EdgeInsets.all(16),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4,
//                           childAspectRatio: 1.5,
//                           crossAxisSpacing: 8,
//                           mainAxisSpacing: 8,
//                         ),
//                         itemCount: students.length,
//                         itemBuilder: (context, index) {
//                           final student = students[index];
//                           bool? isPresent =
//                               student.attendance[selectedDate.toString()]
//                                   ?[selectedPeriod];
//                           Color statusColor = isPresent == null
//                               ? Colors.grey
//                               : isPresent
//                                   ? Colors.green
//                                   : Colors.red;

//                           return GestureDetector(
//                             onTap: () => _showAttendancePopup(student),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: statusColor,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   student.rollNumber ?? "-",
//                                   style: GoogleFonts.inter(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: InkWell(
//         onTap: _navigateToAddStudentsScreen,
//         child: Container(
//           height: 60,
//           width: 180,
//           decoration: BoxDecoration(
//               color: ColorConstants.primaryColor,
//               borderRadius: BorderRadius.circular(16)),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               HugeIcon(
//                   icon: HugeIcons.strokeRoundedAddTeam, color: Colors.white),
//               SizedBox(
//                 width: 6,
//               ),
//               Text(
//                 "Add Students",
//                 style: GoogleFonts.inter(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
