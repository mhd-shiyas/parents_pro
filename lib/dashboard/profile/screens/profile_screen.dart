import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parent_pro/common/custom_appbar.dart';
import 'package:parent_pro/constants/color_constants.dart';
import 'package:provider/provider.dart';

import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/user_controller.dart';
import '../../../widgets/custom_button.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserController>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: "Profile"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Student Details",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorConstants.primaryColor.withOpacity(0.1),
                    border: Border.all(
                      width: 2,
                      color: ColorConstants.primaryColor.withOpacity(0.2),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileWidget(
                      keyValue: "Name",
                      value: authProvider.user?.studentName ?? '',
                    ),
                    SizedBox(height: 16),
                    ProfileWidget(
                      keyValue: "Department",
                      value: authProvider.user?.department ?? '',
                    ),
                    ProfileWidget(
                      keyValue: "Email",
                      value: authProvider.user?.email ?? '',
                    ),
                    SizedBox(height: 16),
                    ProfileWidget(
                      keyValue: "roll_no",
                      value: authProvider.user?.rollNumber ?? '',
                      isDivider: false,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 26,
              ),
              Text(
                "Address",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorConstants.primaryColor.withOpacity(0.1),
                    border: Border.all(
                      width: 2,
                      color: ColorConstants.primaryColor.withOpacity(0.2),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileWidget(
                      keyValue: "House",
                      value: authProvider.user?.address ?? '',
                    ),
                    SizedBox(height: 16),
                    ProfileWidget(
                      keyValue: "Place",
                      value: authProvider.user?.city ?? '',
                    ),
                    ProfileWidget(
                      keyValue: "District",
                      value: authProvider.user?.district ?? '',
                    ),
                    SizedBox(height: 16),
                    ProfileWidget(
                      keyValue: "State",
                      value: authProvider.user?.state ?? '',
                    ),
                    SizedBox(height: 16),
                    ProfileWidget(
                      keyValue: "Pincode",
                      value: authProvider.user?.pincode ?? '',
                      isDivider: false,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomButton(
                title: "Logout",
                onTap: () {
                  Provider.of<AuthenticationController>(context, listen: false)
                      .logout(context);
                })),
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
