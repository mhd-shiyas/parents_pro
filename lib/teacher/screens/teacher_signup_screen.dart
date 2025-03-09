import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parent_pro/auth/screens/user_selection_screen.dart';
import 'package:parent_pro/utils/utils.dart';
import 'package:parent_pro/widgets/custom_button.dart';
import 'package:parent_pro/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

import '../../constants/color_constants.dart';
import '../../widgets/custom_textfield.dart';
import '../../auth/controller/auth_controller.dart';

class TeacherSignUpScreen extends StatefulWidget {
  @override
  _TeacherSignUpScreenState createState() => _TeacherSignUpScreenState();
}

class _TeacherSignUpScreenState extends State<TeacherSignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  String? selectedDepartment;
  String? selectedRole;
  File? _image;

  bool _isLoading = false;

  void _login() async {
    final authProvider =
        Provider.of<AuthenticationController>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await authProvider.registerTeacher(
          id: "",
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          department: selectedDepartment!,
          role: selectedRole!,
          password: passwordController.text.trim(),
          image: _image,
          onSuccess: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserSelectionScreen(),
                ));
          });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthenticationController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teacher Signup',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorConstants.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Teacher Registration',
                style: GoogleFonts.inter(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: ColorConstants.primaryColor,
                ),
              ),
              Text('Enter your details to create an account',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 20),
              CustomTextfield(
                label: "Name",
                hint: "Name",
                controller: nameController,
              ),
              SizedBox(
                height: 10,
              ),
              ButtonTheme(
                alignedDropdown: true,
                child: CustomDropdownWidget(
                  title: "Department",
                  hintText: "Department",
                  value: selectedDepartment,
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value;
                    });
                  },
                  items: Utils.departments
                      .map(
                        (e) => DropdownMenuItem(
                            value: e.value, child: Text(e.label!)),
                      )
                      .toList(),
                  validator: (val) {
                    if (val == null) {
                      return "Select a Grade";
                    }
                    return null;
                  },
                ),
              ),
              ButtonTheme(
                alignedDropdown: true,
                child: CustomDropdownWidget(
                  title: "Role",
                  hintText: "Role",
                  value: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                  items: Utils.teachersRole
                      .map(
                        (e) => DropdownMenuItem(
                            value: e.value, child: Text(e.label!)),
                      )
                      .toList(),
                  validator: (val) {
                    if (val == null) {
                      return "Select a Role";
                    }
                    return null;
                  },
                ),
              ),
              CustomTextfield(
                label: "Email",
                hint: "Email",
                controller: emailController,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextfield(
                label: "Phone",
                hint: "Phone",
                controller: phoneController,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextfield(
                label: "Password",
                hint: "Password",
                controller: passwordController,
              ),
              SizedBox(height: 16),
              _image == null
                  ? Center(child: Text('No Image Selected'))
                  : Center(child: Image.file(_image!, height: 100, width: 100)),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  label: Text(
                    "Pick Profile Image",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: ColorConstants.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCameraLens,
                    color: ColorConstants.primaryColor,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: CustomButton(
                  title: "Submit for Approval",
                  onTap: _login,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
