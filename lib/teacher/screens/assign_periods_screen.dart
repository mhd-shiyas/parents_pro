import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parent_pro/common/custom_appbar.dart';
import 'package:parent_pro/teacher/controller/assign_period_controller.dart';
import 'package:parent_pro/utils/utils.dart';
import 'package:parent_pro/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import '../model/teacher_model.dart';
import '../../widgets/custom_textfield.dart';
import 'package:parent_pro/constants/color_constants.dart';

class AssignPeriodsScreen extends StatefulWidget {
  @override
  _AssignPeriodsScreenState createState() => _AssignPeriodsScreenState();
}

class _AssignPeriodsScreenState extends State<AssignPeriodsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AssignPeriodController>(context, listen: false).loadTeachers();
  }

  void _assignPeriod(Teacher teacher) {
    int? selectedSemester;
    String? selectedSubject;
    String? selectedDepartment;
    TextEditingController _paperCodeController = TextEditingController();

    final List<int> _semester = List.generate(8, (index) => index + 1);

    showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text("Assign Periods for ${teacher.name}"),
          content: Column(
            children: [
              // Container(
              //   height: 60,
              //   width: double.infinity,
              //   padding: EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(
              //         width: 1,
              //         color: Colors.grey,
              //       )),
              //   child: DropdownButtonFormField<String>(
              //     decoration: InputDecoration(
              //       labelText: "",
              //       border: InputBorder.none,
              //     ),
              //     items:
              //         ["Semester 1", "Semester 2", "Semester 3", "Semester 4"]
              //             .map((semester) => DropdownMenuItem(
              //                   value: semester,
              //                   child: Text(semester),
              //                 ))
              //             .toList(),
              //     onChanged: (value) => selectedSemester = value,
              //   ),
              // ),

              // Container(
              //   height: 60,
              //   width: double.infinity,
              //   padding: EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(
              //         width: 1,
              //         color: Colors.grey,
              //       )),
              //   child: DropdownButtonFormField<String>(
              //     decoration: InputDecoration(
              //       labelText: "Select Subject",
              //       border: InputBorder.none,
              //     ),
              //     items: ["Math", "Science", "English", "History"]
              //         .map((subject) => DropdownMenuItem(
              //               value: subject,
              //               child: Text(subject),
              //             ))
              //         .toList(),
              //     onChanged: (value) => selectedSubject = value,
              //   ),
              // ),
              // SizedBox(
              //   height: 12,
              // ),

              DropdownButton<int>(
                value: selectedSemester, // Currently selected value
                hint: Text('Select Semester'), // Hint text
                onChanged: (int? newValue) {
                  setState(() {
                    selectedSemester = newValue; // Update the selected value
                  });
                },
                items: _semester.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()), // Display the number as text
                  );
                }).toList(),
              ),
              // CustomDropdownWidget(
              //   title: "Select Semester",
              //   value: selectedSemester,
              //   onChanged: (value) {
              //     setState(() {
              //       selectedSemester = value;
              //     });
              //   },
              //   items: Utils.semesters
              //       .map((semester) => DropdownMenuItem(
              //             value: semester.value,
              //             child: Text(semester.label ?? ''),
              //           ))
              //       .toList(),
              //   validator: (val) {
              //     if (val == null) {
              //       return "Select a Semester";
              //     }
              //     return null;
              //   },
              // ),

              CustomDropdownWidget(
                title: "Select Subject",
                value: selectedSubject,
                onChanged: (value) {
                  setState(() {
                    selectedSubject = value;
                  });
                },
                items: Utils.subjects
                    .map((subject) => DropdownMenuItem(
                          value: subject.value,
                          child: Text(subject.label ?? ''),
                        ))
                    .toList(),
                validator: (val) {
                  if (val == null) {
                    return "Select a Role";
                  }
                  return null;
                },
              ),
              CustomDropdownWidget(
                title: "Select Department",
                value: selectedDepartment,
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                  });
                },
                items: Utils.departments
                    .map((department) => DropdownMenuItem(
                          value: department.value,
                          child: Text(department.label ?? ''),
                        ))
                    .toList(),
                validator: (val) {
                  if (val == null) {
                    return "Select a Role";
                  }
                  return null;
                },
              ),
              // Container(
              //   height: 60,
              //   width: double.infinity,
              //   padding: EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(
              //         width: 1,
              //         color: Colors.grey,
              //       )),
              //   child: DropdownButtonFormField<String>(
              //     decoration: InputDecoration(
              //       labelText: "Select Department",
              //       border: InputBorder.none,
              //     ),
              //     value: selectedDepartment,
              //     items: Utils.departments
              //         .map((department) => DropdownMenuItem(
              //               value: department.value,
              //               child: Text(department.label ?? ''),
              //             ))
              //         .toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         selectedDepartment = value;
              //       });
              //     },
              //   ),
              // ),

              Column(
                children: [
                  CustomTextfield(
                    label: "",
                    hint: "Enter Paper Code",
                    controller: _paperCodeController,
                  ),
                  Text(
                    "Eg: Department ShortForm + Semester + Subject No. (BCA31)",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  )
                ],
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
                if (selectedSemester != null &&
                    selectedSubject != null &&
                    selectedDepartment != null &&
                    _paperCodeController.text.isNotEmpty) {
                  Provider.of<AssignPeriodController>(context, listen: false)
                      .assignPeriod(
                          teacher.id ?? '',
                          selectedSemester!,
                          selectedSubject!,
                          selectedDepartment!,
                          _paperCodeController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: Text("Assign"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Assign Periods"),
      body: Consumer<AssignPeriodController>(
        builder: (context, teacherController, child) {
          return ListView.builder(
            itemCount: teacherController.teachers.length,
            itemBuilder: (context, index) {
              final teacher = teacherController.teachers[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(teacher.photoUrl ?? ''),
                ),
                title: Text(teacher.name ?? '',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Text("Department: ${teacher.department}"),
                trailing: IconButton(
                  icon: Icon(Icons.assignment,
                      color: ColorConstants.primaryColor),
                  onPressed: () => _assignPeriod(teacher),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
