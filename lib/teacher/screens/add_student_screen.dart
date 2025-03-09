import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:parent_pro/common/custom_appbar.dart';
import 'package:parent_pro/constants/color_constants.dart';
import 'package:parent_pro/teacher/model/student_model.dart';
import 'package:parent_pro/utils/utils.dart';
import 'package:parent_pro/widgets/custom_button.dart';
import 'package:parent_pro/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_textfield.dart';
import '../controller/students_controller.dart';

class AddStudentScreen extends StatefulWidget {
  final String department;
  const AddStudentScreen({super.key, required this.department});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _castController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _admissionDateController =
      TextEditingController();
  final TextEditingController _admissionNumberController =
      TextEditingController();
  final TextEditingController _admisssionYearController =
      TextEditingController();
  int? _selectedSemester; // Default to 1st Year
  String? _selectedGender;
  DateTime? _selectedAdmissionDate;
  String? _selectedDepartment;

  void _nextPage() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(_currentPage,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _selectAdmissionDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedAdmissionDate) {
      setState(() {
        _selectedAdmissionDate = pickedDate;
      });
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(_currentPage,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _submit() {
    final student = StudentModel(
      studentId: '',
      studentName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneNumberController.text,
      currentSemester: _selectedSemester,
      rollNumber: _rollNumberController.text.trim(),
      admissionDate: _selectedAdmissionDate?.toIso8601String() ?? '',
      admissionNumber: _admissionNumberController.text.trim(),
      admisssionYear: _admisssionYearController.text.trim(),
      dob: _dobController.text.trim(),
      gender: _selectedGender,
      bloodGroup: _bloodGroupController.text.trim(),
      department: _selectedDepartment,
      nationality: _nationalityController.text.trim(),
      religion: _religionController.text.trim(),
      category: _categoryController.text.trim(),
      cast: _castController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      district: _districtController.text.trim(),
      state: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
    );

    Provider.of<StudentController>(context, listen: false)
        .addStudent(student, _dobController.text)
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: "Add Student"),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: LinearProgressIndicator(
              minHeight: 5,
              borderRadius: BorderRadius.circular(5),
              value: (_currentPage + 1) / 3,
              backgroundColor: Colors.grey[300],
              valueColor:
                  AlwaysStoppedAnimation<Color>(ColorConstants.primaryColor),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _personalInfoForm(),
                _accountInfoForm(),
                _academicInfoForm(),
              ],
            ),
          ),
          _bottomNavigation()
        ],
      ),
    );
  }

  Widget _bottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            SizedBox(
                width: 150,
                height: 50,
                child: CustomButton(
                    textSize: 15, title: "Back", onTap: _prevPage)),
          if (_currentPage < 2)
            SizedBox(
                width: 150,
                height: 50,
                child: CustomButton(
                    textSize: 15, title: "Next", onTap: _nextPage)),
          if (_currentPage == 2)
            SizedBox(
                width: 150,
                height: 50,
                child: CustomButton(
                    textSize: 15, title: "Submit", onTap: _submit)),
        ],
      ),
    );
  }

  // Personal Information Form
  Widget _personalInfoForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Personal Information",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 20,
            ),
            CustomTextfield(
                label: "Name", hint: "Name", controller: _nameController),
            CustomTextfield(
                label: "DOB",
                hint: "Date of Birth",
                controller: _dobController),
            const Text(
              'Select Gender:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Row(
              children: [
                Checkbox(
                  activeColor: ColorConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  value: _selectedGender == 'male',
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value! ? 'male' : null;
                    });
                  },
                ),
                const Text(
                  'Male',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                Checkbox(
                  activeColor: ColorConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  value: _selectedGender == 'female',
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value! ? 'female' : null;
                    });
                  },
                ),
                const Text(
                  'Female',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            CustomTextfield(
                label: "Blood Group",
                hint: "Blood Group",
                controller: _bloodGroupController),
            CustomTextfield(
                label: "Address",
                hint: "Address",
                controller: _addressController),
            CustomTextfield(
                label: "Religion",
                hint: "Religion",
                controller: _religionController),
            CustomTextfield(
                label: "Cast", hint: "Cast", controller: _castController),
            CustomTextfield(
                label: "Category",
                hint: "Category",
                controller: _categoryController),
            CustomTextfield(
                label: "City", hint: "City", controller: _cityController),
            CustomTextfield(
                label: "District",
                hint: "District",
                controller: _districtController),
            CustomTextfield(
                label: "State", hint: "State", controller: _stateController),
            CustomTextfield(
                label: "Pincode",
                hint: "Pincode",
                controller: _pincodeController),
            CustomTextfield(
                label: "Nationality",
                hint: "Nationality",
                controller: _nationalityController),
          ],
        ),
      ),
    );
  }

  // Account Information Form
  Widget _accountInfoForm() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Account Information",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(
            height: 20,
          ),
          CustomTextfield(
              label: "Email", hint: "Email", controller: _emailController),
          CustomTextfield(
              label: "Phone Number",
              hint: "Phone Number",
              controller: _phoneNumberController),
        ],
      ),
    );
  }

  // Academic Information Form
  Widget _academicInfoForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Academic Information",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 20,
            ),
            CustomTextfield(
                label: "Roll Number",
                hint: "Roll Number",
                controller: _rollNumberController),
            CustomTextfield(
                label: "Admission Number",
                hint: "Admission Number",
                controller: _admissionNumberController),
            GestureDetector(
              onTap: _selectAdmissionDate,
              child: AbsorbPointer(
                child: CustomTextfield(
                  suffix: HugeIcon(
                      icon: HugeIcons.strokeRoundedCalendar03,
                      color: ColorConstants.primaryColor),
                  label: "Admission Date",
                  hint: _selectedAdmissionDate == null
                      ? "Admission Date"
                      : "${_selectedAdmissionDate!.toLocal()}".split(' ')[0],
                ),
              ),
            ),
            // CustomTextfield(
            //     label: "Admission Date",
            //     hint: "Admission Date",
            //     controller: _admissionDateController),
            CustomTextfield(
                label: "Admission Year",
                hint: "Admission Year",
                controller: _admisssionYearController),
            CustomDropdownWidget(
              hintText: "Select Deparment",
              title: "Select Department",
              value: _selectedDepartment,
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                });
              },
              items: Utils.departments
                  .map((dep) => DropdownMenuItem(
                        child: Text(dep.label ?? ''),
                        value: dep.value,
                      ))
                  .toList(),
              validator: (val) {
                if (val == null) {
                  return "Select a Semester";
                }
                return null;
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Semester",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                ButtonTheme(
                  alignedDropdown: true,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey)),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<int>(
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Select Semester",
                            labelStyle: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            contentPadding: EdgeInsets.all(10)),
                        value: _selectedSemester,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedSemester = newValue!;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                              value: 1, child: Text("1st Semester")),
                          DropdownMenuItem(
                              value: 2, child: Text("2nd Semester")),
                          DropdownMenuItem(
                              value: 3, child: Text("3rd Semester")),
                          DropdownMenuItem(
                              value: 4, child: Text("4th Semester")),
                          DropdownMenuItem(
                              value: 5, child: Text("5th Semester")),
                          DropdownMenuItem(
                              value: 6, child: Text("6th Semester")),
                          DropdownMenuItem(
                              value: 7, child: Text("7th Semester")),
                          DropdownMenuItem(
                              value: 8, child: Text("8th Semester")),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}







// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:parent_pro/teacher/model/student_model.dart';
// import 'package:provider/provider.dart';

// import '../../widgets/custom_textfield.dart';
// import '../controller/students_controller.dart';

// class AddStudentScreen extends StatefulWidget {
//   final String department;
//   const AddStudentScreen({super.key, required this.department});

//   @override
//   _AddStudentScreenState createState() => _AddStudentScreenState();
// }

// class _AddStudentScreenState extends State<AddStudentScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _genderController = TextEditingController();
//   final TextEditingController _bloodGroupController = TextEditingController();
//   final TextEditingController _departmentController = TextEditingController();
//   final TextEditingController _nationalityController = TextEditingController();
//   final TextEditingController _religionController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();
//   final TextEditingController _castController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _placeController = TextEditingController();
//   final TextEditingController _postOfficeController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _districtController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _pincodeController = TextEditingController();
//   final TextEditingController _rollNumberController = TextEditingController();
//   final TextEditingController _admissionDateController =
//       TextEditingController();
//   final TextEditingController _admissionNumberController =
//       TextEditingController();
//   final TextEditingController _admisssionYearController =
//       TextEditingController();
//   int? _selectedSemester; // Default to 1st Year

//   void _submit() {
//     final student = StudentModel(
//       studentId: '',
//       studentName: _nameController.text.trim(),
//       email: _emailController.text.trim(),
//       phoneNumber: _phoneNumberController.text,
//       currentSemester: _selectedSemester,
//       rollNumber: _rollNumberController.text.trim(),
//       admissionDate: _admissionDateController.text.trim(),
//       admissionNumber: _admissionNumberController.text.trim(),
//       admisssionYear: _admisssionYearController.text.trim(),
//       dob: _dobController.text.trim(),
//       gender: _genderController.text.trim(),
//       bloodGroup: _bloodGroupController.text.trim(),
//       department: _departmentController.text.trim(),
//       nationality: _nationalityController.text.trim(),
//       religion: _religionController.text.trim(),
//       category: _categoryController.text.trim(),
//       cast: _castController.text.trim(),
//       houseName: _addressController.text.trim(),
//       place: _placeController.text.trim(),
//       postOffice: _postOfficeController.text.trim(),
//       city: _cityController.text.trim(),
//       district: _districtController.text.trim(),
//       state: _stateController.text.trim(),
//       pincode: _pincodeController.text.trim(),
//     );

//     Provider.of<StudentController>(context, listen: false)
//         .addStudent(student, _dobController.text)
//         .then((_) {
//       Navigator.pop(context); // Go back to student list screen
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Student')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               CustomTextfield(
//                 label: "Name",
//                 hint: "Name",
//                 controller: _nameController,
//               ),
//               CustomTextfield(
//                 label: "Email",
//                 hint: "Email",
//                 controller: _emailController,
//               ),
//               CustomTextfield(
//                 label: "Phone Number",
//                 hint: "Phone Number",
//                 controller: _phoneNumberController,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey)),
//                 child: ButtonTheme(
//                   alignedDropdown: true,
//                   child: DropdownButtonFormField<int>(
//                     decoration: InputDecoration(
//                         border: InputBorder.none,
//                         labelText: "Select Semester",
//                         contentPadding: EdgeInsets.all(10)),
//                     value: _selectedSemester,
//                     onChanged: (int? newValue) {
//                       setState(() {
//                         _selectedSemester = newValue!;
//                       });
//                     },
//                     items: [
//                       DropdownMenuItem(value: 1, child: Text("1st Year")),
//                       DropdownMenuItem(value: 2, child: Text("2nd Year")),
//                       DropdownMenuItem(value: 3, child: Text("3rd Year")),
//                       DropdownMenuItem(value: 4, child: Text("4th Year")),
//                     ],
//                   ),
//                 ),
//               ),
//               CustomTextfield(
//                 label: "Roll Number",
//                 hint: "Roll Number",
//                 controller: _rollNumberController,
//               ),
//               CustomTextfield(
//                 label: "Admission Number",
//                 hint: "Admission Number",
//                 controller: _admissionNumberController,
//               ),
//               CustomTextfield(
//                 label: "Admission Date",
//                 hint: "Admission Date",
//                 controller: _admissionDateController,
//               ),
//               CustomTextfield(
//                 label: "Admission Year",
//                 hint: "Admission Year",
//                 controller: _admisssionYearController,
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               CustomTextfield(
//                 label: "DOB",
//                 hint: "DOB",
//                 controller: _dobController,
//               ),
//               CustomTextfield(
//                 label: "Gender",
//                 hint: "Gender",
//                 controller: _genderController,
//               ),
//               CustomTextfield(
//                 label: "BloodGroup",
//                 hint: "BloodGroup",
//                 controller: _bloodGroupController,
//               ),
//               CustomTextfield(
//                 label: "Department",
//                 hint: "Department",
//                 controller: _departmentController,
//               ),
//               CustomTextfield(
//                 label: "Nationality",
//                 hint: "Nationality",
//                 controller: _nationalityController,
//               ),
//               CustomTextfield(
//                 label: "Religion",
//                 hint: "Religion",
//                 controller: _religionController,
//               ),
//               CustomTextfield(
//                 label: "Category",
//                 hint: "Category",
//                 controller: _categoryController,
//               ),
//               CustomTextfield(
//                 label: "Cast",
//                 hint: "Cast",
//                 controller: _castController,
//               ),
//               CustomTextfield(
//                 label: "House",
//                 hint: "House",
//                 controller: _addressController,
//               ),
//               CustomTextfield(
//                 label: "Place",
//                 hint: "Place",
//                 controller: _placeController,
//               ),
//               CustomTextfield(
//                 label: "Post Office",
//                 hint: "Post Office",
//                 controller: _postOfficeController,
//               ),
//               CustomTextfield(
//                 label: "City",
//                 hint: "City",
//                 controller: _cityController,
//               ),
//               CustomTextfield(
//                 label: "District",
//                 hint: "District",
//                 controller: _districtController,
//               ),
//               CustomTextfield(
//                 label: "State",
//                 hint: "State",
//                 controller: _stateController,
//               ),
//               CustomTextfield(
//                 label: "pincode",
//                 hint: "pincode",
//                 controller: _pincodeController,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(onPressed: _submit, child: Text('Add Student')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

