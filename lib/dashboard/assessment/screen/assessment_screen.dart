import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parent_pro/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../auth/controller/student_assessment_controller.dart';
import '../../../constants/color_constants.dart';

class StudentAssessmentsScreen extends StatefulWidget {
  final String studentId;

  const StudentAssessmentsScreen({Key? key, required this.studentId})
      : super(key: key);

  @override
  _StudentAssessmentsScreenState createState() =>
      _StudentAssessmentsScreenState();
}

class _StudentAssessmentsScreenState extends State<StudentAssessmentsScreen> {
  int selectedSemester = 1; // Default semester

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: "Student Assessments"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Semester Dropdown Below AppBar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select Semester:",
                      style: GoogleFonts.inter(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1.5,
                          color: ColorConstants.primaryColor,
                        )),
                    child: DropdownButton<int>(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      value: selectedSemester,
                      items: List.generate(8, (index) => index + 1)
                          .map((sem) => DropdownMenuItem(
                                value: sem,
                                child: Text("Semester $sem"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedSemester = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: Provider.of<StudentAssessmentController>(context,
                        listen: false)
                    .getAssessments(widget.studentId, selectedSemester),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                            "No assessments found for Semester $selectedSemester"));
                  }

                  List<Map<String, dynamic>> assessments = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: () => Provider.of<StudentAssessmentController>(
                            context,
                            listen: false)
                        .getAssessments(widget.studentId, selectedSemester),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        height: 12,
                      ),
                      itemCount: assessments.length,
                      itemBuilder: (context, index) {
                        final assessment = assessments[index];
                        bool isSubmitted = assessment['submitted'] ?? false;

                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2, 3),
                                  blurRadius: 10,
                                  color: Colors.grey.withOpacity(0.2),
                                )
                              ]),
                          child: ListTile(
                            title: Text(assessment['name'],
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Type: ${assessment['type']}"),
                                Text("Due Date: ${assessment['due_date']}"),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: isSubmitted
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                  ),
                                  child: Text(
                                      "Status: ${isSubmitted ? "Submitted" : "Not Submitted"}",
                                      style: GoogleFonts.inter(
                                          color: isSubmitted
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
