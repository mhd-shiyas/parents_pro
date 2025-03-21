import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parent_pro/common/custom_appbar.dart';
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
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: "Semester Fees"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : semesterFees.isEmpty
              ? Center(child: Text("No semester fees added"))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 12,
                    ),
                    itemCount: semesterFees.length,
                    itemBuilder: (context, index) {
                      final fee = semesterFees[index];

                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(2, 3),
                                blurRadius: 10,
                                color: Colors.grey.withOpacity(0.2),
                              )
                            ]),
                        child: ListTile(
                          title: Text(
                            "Semester ${fee['semester']}",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            "Fee: ₹${fee['amount']}.00",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: fee['paid'] == true
                              ? Chip(
                                  label: Text("Paid",
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.green,
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    _feesController.startPayment(fee['amount'],
                                        widget.studentId, fee['semester']);
                                  },
                                  child: Text("Pay Now"),
                                ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
