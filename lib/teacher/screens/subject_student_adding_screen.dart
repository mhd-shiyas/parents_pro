import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:parent_pro/common/custom_appbar.dart';
import 'package:parent_pro/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../controller/students_controller.dart';
import '../model/student_model.dart';
import 'package:parent_pro/constants/color_constants.dart';

class StudentAddingToSubjectsScreen extends StatefulWidget {
  final String subject;

  const StudentAddingToSubjectsScreen({super.key, required this.subject});

  @override
  _StudentAddingToSubjectsScreenState createState() =>
      _StudentAddingToSubjectsScreenState();
}

class _StudentAddingToSubjectsScreenState
    extends State<StudentAddingToSubjectsScreen> {
  String? selectedDepartment;
  TextEditingController searchController = TextEditingController();
  List<StudentModel> filteredStudents = [];
  Set<String> selectedStudentIds = {};
  List<StudentModel> assignedStudents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
    searchController.addListener(() {
      _filterStudents(searchController.text);
    });
  }

  Future<void> _loadAllData() async {
    setState(() => isLoading = true);
    final studentController =
        Provider.of<StudentController>(context, listen: false);
    await studentController.loadAllStudents(); // Load all students
    assignedStudents = await studentController
        .loadStudentsBySubject(widget.subject); // Load assigned students
    _filterStudents(""); // Initialize filtered list
    setState(() => isLoading = false);
  }

  void _filterStudents(String query) {
    final studentController =
        Provider.of<StudentController>(context, listen: false);
    setState(() {
      filteredStudents = studentController.students.where((student) {
        final matchesSearch =
            student.studentName!.toLowerCase().contains(query.toLowerCase());
        final matchesDept = selectedDepartment == null ||
            selectedDepartment == "All" ||
            student.department == selectedDepartment;
        final notAssigned = !assignedStudents
            .any((assigned) => assigned.studentId == student.studentId);
        return matchesSearch && matchesDept && notAssigned;
      }).toList();
      print(
          "Filtered ${filteredStudents.length} students: ${filteredStudents.map((s) => s.studentName).toList()}");
    });
  }

  void _toggleStudentSelection(StudentModel student) {
    setState(() {
      if (selectedStudentIds.contains(student.studentId)) {
        selectedStudentIds.remove(student.studentId);
      } else {
        selectedStudentIds.add(student.studentId!);
      }
    });
  }

  void _addSelectedStudents() {
    final studentController =
        Provider.of<StudentController>(context, listen: false);
    for (String studentId in selectedStudentIds) {
      studentController.assignStudentToSubject(studentId, widget.subject);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Students added successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Add Students"),
      //  AppBar(
      //   title: const Text("Add Students"),
      //   backgroundColor: ColorConstants.primaryColor,
      //   actions: [
      //     TextButton(
      //       onPressed:
      //           selectedStudentIds.isNotEmpty ? _addSelectedStudents : null,
      //       child: const Text("Add", style: TextStyle(color: Colors.white)),
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Students...",
                prefixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch01, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12).copyWith(top: 0, bottom: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: 2,
                      color: ColorConstants.primaryColor.withOpacity(0.2))),
              child: DropdownButtonFormField<String>(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowDown01,
                  color: ColorConstants.primaryColor,
                ),
                decoration: const InputDecoration(
                    labelText: "Filter by Department",
                    border: InputBorder.none),
                value: selectedDepartment,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDepartment = newValue;
                    _filterStudents(searchController.text);
                  });
                },
                items: ["All", "Computer Science", "Mathematics", "Physics"]
                    .map((dept) =>
                        DropdownMenuItem(value: dept, child: Text(dept)))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Consumer<StudentController>(
                      builder: (context, studentController, child) {
                        if (filteredStudents.isEmpty) {
                          return const Center(
                              child: Text("No students available to add"));
                        }
                        return ListView.builder(
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];
                            bool isSelected =
                                selectedStudentIds.contains(student.studentId);
                            return ListTile(
                              title: Text(
                                student.studentName ?? "",
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Roll No: ${student.rollNumber ?? 'N/A'}"),
                                  Text(
                                      "Department: ${student.department ?? 'N/A'}"),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.add_circle,
                                  color: isSelected
                                      ? Colors.green
                                      : ColorConstants.primaryColor,
                                ),
                                onPressed: () =>
                                    _toggleStudentSelection(student),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: selectedStudentIds.isNotEmpty ? _addSelectedStudents : null,
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorConstants.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          height: 60,
          child: Center(
            child: Text(
              "Add",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
