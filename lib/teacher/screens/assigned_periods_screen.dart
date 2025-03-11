import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:parent_pro/common/custom_appbar.dart';
import 'package:parent_pro/teacher/screens/attendance_screen.dart';
import 'package:provider/provider.dart';
import '../controller/teacher_controller.dart';
import '../model/teacher_model.dart';

class TeacherAssignedPeriodsScreen extends StatefulWidget {
  final String teacherId;

  const TeacherAssignedPeriodsScreen({super.key, required this.teacherId});

  @override
  _TeacherAssignedPeriodsScreenState createState() =>
      _TeacherAssignedPeriodsScreenState();
}

class _TeacherAssignedPeriodsScreenState
    extends State<TeacherAssignedPeriodsScreen> {
  Teacher? _teacher;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeacherData();
  }

  Future<void> _fetchTeacherData() async {
    final teacherController =
        Provider.of<TeacherController>(context, listen: false);
    try {
      final teacher = await teacherController.getTeacherById(widget.teacherId);
      setState(() {
        _teacher = teacher;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch teacher data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "My Assigned Periods"),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _teacher == null || _teacher!.assignedPeriods.isEmpty
              ? Center(child: Text("No assigned periods found"))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _teacher!.assignedPeriods.length,
                  itemBuilder: (context, index) {
                    final period = _teacher!.assignedPeriods[index];
                    return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceMarkingScreen(
                              subject: period['subject'] ?? '',
                              paperCode: period['paper_code'] ?? '',
                              semester:
                                  int.tryParse(period['semester'].toString()) ??
                                      0, // ✅ Fixed conversion
                              teacherId: widget.teacherId,
                            ),
                          )),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                            "${period['subject']} (${period['paper_code']})",
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Semester: ${int.tryParse(period['semester'].toString()) ?? 0}\nDepartment: ${period['department']}",
                            style: GoogleFonts.inter(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
