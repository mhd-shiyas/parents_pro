import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/controller/fees_controller.dart';

class FeesScreen extends StatefulWidget {
  final String studentId;

  const FeesScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  _FeesScreenState createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  late FeesController _feesController;
  bool isLoading = true;
  List<Map<String, dynamic>> semesterFees = [];

  @override
  void initState() {
    super.initState();
    _feesController = Provider.of<FeesController>(context, listen: false);
    _fetchFees();
  }

  Future<void> _fetchFees() async {
    try {
      List<Map<String, dynamic>> fees =
          await _feesController.fetchSemesterFees(widget.studentId);
      setState(() {
        semesterFees = fees;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading fees: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Semester Fees")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : semesterFees.isEmpty
              ? Center(child: Text("No semester fees added"))
              : ListView.builder(
                  itemCount: semesterFees.length,
                  itemBuilder: (context, index) {
                    final fee = semesterFees[index];

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text("Semester ${fee['semester']}"),
                        subtitle: Text("Fee: ₹${fee['amount']}"),
                        trailing: fee['paid'] == true
                            ? Chip(
                                label: Text("Paid",
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.green,
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  _feesController.startPayment(
                                      fee['amount'], widget.studentId, fee['semester']);
                                },
                                child: Text("Pay Now"),
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}
