import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:parent_pro/constants/color_constants.dart';
import 'package:parent_pro/teacher/screens/student_edit_screen.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_textfield.dart';
import '../controller/students_controller.dart';
import '../model/student_model.dart';
import 'add_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  final String department;
  const StudentListScreen({super.key, required this.department});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<StudentModel> _filteredStudents = [];

  void _filterStudents(String query, List<StudentModel> students) {
    setState(() {
      _filteredStudents = students
          .where((student) =>
              student.studentName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    Provider.of<StudentController>(context, listen: false)
        .loadStudents(widget.department);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StudentController()..loadStudents(widget.department),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [],
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: ColorConstants.primaryColor,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context)),
          title: Text(
            "Students",
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => loadStudents(),
          color: ColorConstants.primaryColor,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<StudentController>(
              builder: (context, studentController, child) {
                final students = _filteredStudents.isEmpty
                    ? studentController.students
                    : _filteredStudents;
                return studentController.students.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0)
                                .copyWith(top: 10),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: "Search Students by Name...",
                                  hintStyle: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: ColorConstants.primaryColor
                                          .withOpacity(0.5)),
                                  prefixIcon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedSearch01,
                                    color: ColorConstants.primaryColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: ColorConstants.primaryColor
                                      .withOpacity(0.1),
                                ),
                                onChanged: (query) {
                                  _filterStudents(
                                      query,
                                      Provider.of<StudentController>(context,
                                              listen: false)
                                          .students);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                height: 12,
                              ),
                              itemCount: students.length,
                              itemBuilder: (context, index) {
                                final student = students[index];
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 10,
                                          color: Colors.grey.withOpacity(0.3),
                                        )
                                      ]),
                                  child: ListTile(
                                    title: Text(
                                      student.studentName?.toUpperCase() ?? '',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Department: ${student.department}",
                                          style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          "Current Semester: ${student.currentSemester}",
                                          style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit,
                                          color: ColorConstants.primaryColor),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentEditScreen(
                                                studentId:
                                                    student.studentId ?? '',
                                                // selectedSemester:
                                                //     student.currentSemester ??
                                                //         0,
                                              ),
                                            ));
                                        // _editStudent(student);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorConstants.primaryColor,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddStudentScreen(department: widget.department)),
          ),
          child: Icon(
            Icons.add,
            weight: 10,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _editStudent(StudentModel student) {
    TextEditingController _yearController =
        TextEditingController(text: student.admisssionYear);
    TextEditingController _semesterController =
        TextEditingController(text: student.currentSemester.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Student Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextfield(
              label: "Year",
              hint: "Enter Year",
              controller: _yearController,
            ),
            CustomTextfield(
              label: "Semester",
              hint: "Enter Semester",
              controller: _semesterController,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Provider.of<StudentController>(context, listen: false)
                  .updateStudent(student.studentId!, {
                'admission_year': _yearController.text.trim(),
                'current_semester':
                    int.tryParse(_semesterController.text.trim()) ??
                        student.currentSemester,
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:parent_pro/common/custom_appbar.dart';
// import 'package:parent_pro/constants/color_constants.dart';
// import 'package:provider/provider.dart';
// import '../controller/students_controller.dart';
// import 'add_student_screen.dart';

// class StudentListScreen extends StatefulWidget {
//   final String department;
//   const StudentListScreen({super.key, required this.department});

//   @override
//   State<StudentListScreen> createState() => _StudentListScreenState();
// }

// class _StudentListScreenState extends State<StudentListScreen> {
//   int? _selectedSemester;

//   void _showFilterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Filter by Semester"),
//           content: DropdownButtonFormField<int>(
//             decoration: InputDecoration(labelText: "Select Semester"),
//             value: _selectedSemester,
//             onChanged: (int? newValue) {
//               setState(() {
//                 _selectedSemester = newValue;
//               });
//               Navigator.pop(context);
//             },
//             items: [
//               DropdownMenuItem(value: null, child: Text("All")),
//               DropdownMenuItem(value: 1, child: Text("1st Semester")),
//               DropdownMenuItem(value: 2, child: Text("2nd Semester")),
//               DropdownMenuItem(value: 3, child: Text("3rd Semester")),
//               DropdownMenuItem(value: 4, child: Text("4th Semester")),
//               DropdownMenuItem(value: 5, child: Text("5th Semester")),
//               DropdownMenuItem(value: 6, child: Text("6th Semester")),
//               DropdownMenuItem(value: 7, child: Text("7th Semester")),
//               DropdownMenuItem(value: 8, child: Text("8th Semester")),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadStudents();
//   }

//   Future<void> loadStudents() async {
//     Provider.of<StudentController>(context, listen: false)
//         .loadStudents(widget.department);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => StudentController()..loadStudents(widget.department),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           actions: [
//             IconButton(
//               icon: HugeIcon(
//                 icon: HugeIcons.strokeRoundedFilter,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 _showFilterDialog(context);
//               },
//             ),
//           ],
//           automaticallyImplyLeading: true,
//           centerTitle: true,
//           backgroundColor: ColorConstants.primaryColor,
//           elevation: 0,
//           leading: IconButton(
//               icon: const Icon(
//                 Icons.arrow_back,
//                 color: Colors.white,
//               ),
//               onPressed: () => Navigator.pop(context)),
//           title: Text(
//             "Students",
//             style: const TextStyle(
//               fontWeight: FontWeight.w800,
//               color: Colors.white,
//               fontSize: 20,
//             ),
//           ),
//         ),
//         body: RefreshIndicator(
//           onRefresh: () => loadStudents(),
//           color: ColorConstants.primaryColor,
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Consumer<StudentController>(
//               builder: (context, studentController, child) {
//                 final students = _selectedSemester == null
//                     ? studentController.students
//                     : studentController.students
//                         .where((s) => s.currentSemester == _selectedSemester)
//                         .toList();
//                 return studentController.students.isEmpty
//                     ? Center(child: CircularProgressIndicator())
//                     : ListView.separated(
//                         separatorBuilder: (context, index) => SizedBox(
//                           height: 12,
//                         ),
//                         itemCount: students.length,
//                         itemBuilder: (context, index) {
//                           final student = students[index];
//                           return Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(16),
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     offset: Offset(0, 2),
//                                     blurRadius: 10,
//                                     color: Colors.grey.withOpacity(0.3),
//                                   )
//                                 ]),
//                             child: ListTile(
//                               title: Text(
//                                 student.studentName?.toUpperCase() ?? '',
//                                 style: GoogleFonts.inter(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Department: ${student.department}",
//                                     style: GoogleFonts.inter(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.grey),
//                                   ),
//                                   Text(
//                                     "Current Semester: ${student.currentSemester}",
//                                     style: GoogleFonts.inter(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//               },
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: ColorConstants.primaryColor,
//           onPressed: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     AddStudentScreen(department: widget.department)),
//           ),
//           child: Icon(
//             Icons.add,
//             weight: 10,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
