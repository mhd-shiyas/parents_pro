import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/assessment_controller.dart';

class AddAssessmentScreen extends StatefulWidget {
  final String teacherId;
  final String subject;
  final int semester;
  final String paperCode;

  const AddAssessmentScreen({
    super.key,
    required this.teacherId,
    required this.subject,
    required this.semester,
    required this.paperCode,
  });

  @override
  _AddAssessmentScreenState createState() => _AddAssessmentScreenState();
}

class _AddAssessmentScreenState extends State<AddAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _assessmentType;
  String _assessmentName = '';
  DateTime? _dueDate;
  bool isLoading = false;

  // List of assessment types
  final List<String> _assessmentTypes = ["Assignment", "Quiz", "Project", "Exam"];

  void _submitAssessment() async {
    if (_formKey.currentState!.validate() && _assessmentType != null && _dueDate != null) {
      setState(() => isLoading = true);

      await Provider.of<AssessmentController>(context, listen: false).addAssessment(
        teacherId: widget.teacherId,
        subject: widget.subject,
        semester: widget.semester,
        paperCode: widget.paperCode,
        type: _assessmentType!,
        name: _assessmentName,
        dueDate: _dueDate!,
      );

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Assessment added successfully!")),
      );

      Navigator.pop(context); // Close the screen after adding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Assessment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Assessment Type", style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _assessmentType,
                items: _assessmentTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _assessmentType = value),
                validator: (value) => value == null ? "Please select an assessment type" : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(labelText: "Assessment Name"),
                onChanged: (value) => _assessmentName = value,
                validator: (value) => value == null || value.isEmpty ? "Enter assessment name" : null,
              ),
              SizedBox(height: 16),

              Text("Due Date", style: TextStyle(fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => _dueDate = pickedDate);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_dueDate == null ? "Select Due Date" : "${_dueDate!.toLocal()}".split(' ')[0]),
                ),
              ),
              SizedBox(height: 24),

              ElevatedButton(
                onPressed: isLoading ? null : _submitAssessment,
                child: isLoading ? CircularProgressIndicator() : Text("Add Assessment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
