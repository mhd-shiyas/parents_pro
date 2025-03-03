import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parent_pro/auth/controller/auth_controller.dart';
import 'package:parent_pro/common/custom_appbar.dart';
import 'package:parent_pro/constants/color_constants.dart';
import 'package:parent_pro/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class TeacherProfileScreen extends StatelessWidget {
  final Map<String, dynamic> teacherDetails; // Passing the teacher details

  TeacherProfileScreen({required this.teacherDetails});

  @override
  Widget build(BuildContext context) {
    // Extract teacher details
    String teacherName = teacherDetails['name'] ?? 'Unknown';
    String teacherDepartment = teacherDetails['department'] ?? 'Unknown';
    String teacherEmail = teacherDetails['email'] ?? 'Unknown';
    String teacherPhone = teacherDetails['phone'] ?? 'No Bio Available';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: "Profile"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: ColorConstants.primaryColor,
                child: Text(
                  teacherName[0], // Display the first letter of the name
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorConstants.secondaryColor.withOpacity(0.1),
                  border: Border.all(
                    width: 2,
                    color: ColorConstants.primaryColor.withOpacity(0.2),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileWidget(
                    keyValue: "Name",
                    value: teacherName,
                  ),
                  SizedBox(height: 16),
                  ProfileWidget(
                    keyValue: "Department",
                    value: teacherDepartment,
                  ),
                  SizedBox(height: 16),
                  ProfileWidget(
                    keyValue: "Email",
                    value: teacherEmail,
                  ),
                  SizedBox(height: 16),
                  ProfileWidget(
                    keyValue: "Phone Number",
                    value: teacherPhone,
                    isDivider: false,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 60,
                width: double.infinity,
                child: CustomButton(
                    title: "Logout",
                    onTap: () {
                      Provider.of<AuthenticationController>(context,
                              listen: false)
                          .logout(context);
                    }))
          ],
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String keyValue;
  final String value;
  final bool? isDivider;

  const ProfileWidget({
    super.key,
    required this.keyValue,
    required this.value,
    this.isDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$keyValue:  '.toUpperCase(),
              style:
                  GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        isDivider == true
            ? Divider(
                color: ColorConstants.primaryColor.withOpacity(0.2),
              )
            : SizedBox()
      ],
    );
  }
}
