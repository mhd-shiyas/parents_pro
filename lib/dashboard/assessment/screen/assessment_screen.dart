import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/controller/student_assessment_controller.dart';

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
      appBar: AppBar(title: Text("Student Assessments")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Semester Dropdown Below AppBar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Select Semester:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<int>(
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
                return ListView.builder(
                  itemCount: assessments.length,
                  itemBuilder: (context, index) {
                    final assessment = assessments[index];
                    bool isSubmitted = assessment['submitted'] ?? false;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(assessment['name'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Type: ${assessment['type']}"),
                            Text("Due Date: ${assessment['due_date']}"),
                            Text(
                                "Status: ${isSubmitted ? "Submitted" : "Not Submitted"}",
                                style: TextStyle(
                                    color:
                                        isSubmitted ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
