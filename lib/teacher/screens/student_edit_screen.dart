import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controller/assessment_controller.dart';
import '../controller/students_controller.dart';

class StudentEditScreen extends StatefulWidget {
  final String studentId;

  const StudentEditScreen({Key? key, required this.studentId})
      : super(key: key);

  @override
  _StudentEditScreenState createState() => _StudentEditScreenState();
}

class _StudentEditScreenState extends State<StudentEditScreen>
    with SingleTickerProviderStateMixin {
  int currentSemester = 0;
  String currentYear = "";
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStudentDetails();
  }

  Future<void> _loadStudentDetails() async {
    final student = await Provider.of<StudentController>(context, listen: false)
        .getStudentById(widget.studentId);
    if (student != null) {
      setState(() {
        currentSemester = student['current_semester'];
        currentYear = student['admission_year'];
      });
    }
  }

  void _editStudent() {
    TextEditingController _yearController =
        TextEditingController(text: currentYear);
    TextEditingController _semesterController =
        TextEditingController(text: currentSemester.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Student Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _yearController,
              decoration: InputDecoration(labelText: "Year"),
            ),
            TextField(
              controller: _semesterController,
              decoration: InputDecoration(labelText: "Semester"),
              keyboardType: TextInputType.number,
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
                  .updateStudent(widget.studentId, {
                'admission_year': _yearController.text.trim(),
                'current_semester':
                    int.tryParse(_semesterController.text.trim()) ??
                        currentSemester,
              });
              setState(() {
                currentYear = _yearController.text.trim();
                currentSemester =
                    int.tryParse(_semesterController.text.trim()) ??
                        currentSemester;
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _addSemesterFee() {
    TextEditingController semesterController = TextEditingController();
    TextEditingController feeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Semester Fee"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: semesterController,
              decoration: InputDecoration(labelText: "Semester Number"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: feeController,
              decoration: InputDecoration(labelText: "Semester Fee"),
              keyboardType: TextInputType.number,
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
              int semester = int.tryParse(semesterController.text.trim()) ?? 0;
              int fee = int.tryParse(feeController.text.trim()) ?? 0;
              if (semester > 0 && fee > 0) {
                Provider.of<StudentController>(context, listen: false)
                    .addSemesterFee(widget.studentId, semester, fee);
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Semester & Year with Edit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Admission Year: $currentYear",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text("Current Semester: $currentSemester",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _editStudent,
                )
              ],
            ),

            SizedBox(height: 16),

            // Tab Bar for Assessments & Fees
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "Assessments"),
                Tab(text: "Semester Fees"),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAssessmentsSection(),
                  _buildFeesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Assessments Section
  Widget _buildAssessmentsSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Provider.of<AssessmentController>(context, listen: false)
          .fetchAssessments(widget.studentId, currentSemester),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No assessments added"));
        }

        List<Map<String, dynamic>> assessments = snapshot.data!;
        return ListView.builder(
          itemCount: assessments.length,
          itemBuilder: (context, index) {
            final assessment = assessments[index];
            bool isSubmitted = assessment.containsKey('submitted')
                ? assessment['submitted']
                : false;

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
                  ],
                ),
                trailing: Switch(
                  value: isSubmitted,
                  onChanged: (value) {
                    Provider.of<AssessmentController>(context, listen: false)
                        .updateAssessmentSubmission(
                            widget.studentId, currentSemester, index, value);
                    setState(() {});
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 📌 Semester Fees Section
  // 📌 Semester Fees Section
  Widget _buildFeesSection() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _addSemesterFee,
          child: Text("Add Semester Fee"),
        ),
        Expanded(
            child: Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: Provider.of<StudentController>(context, listen: false)
                .getSemesterFees(widget.studentId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No semester fees added"));
              }

              List<Map<String, dynamic>> fees = snapshot.data!;
              return ListView.builder(
                itemCount: fees.length,
                itemBuilder: (context, index) {
                  final fee = fees[index];
                  return Card(
                    child: ListTile(
                        title: Text("Semester ${fee['semester']}"),
                        subtitle: Text("Fee: ${fee['amount']}"),
                        trailing: Text(
                          fee['paid'] ? "Paid" : "Not Paid",
                          style: GoogleFonts.inter(
                            color: fee['paid'] ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        )),
                  );
                },
              );
            },
          ),
        )),
      ],
    );
  }
}
