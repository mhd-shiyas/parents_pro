import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

class ValueLabel {
  final String? value;
  final String? label;

  ValueLabel({this.value, this.label});
}

class Utils {
  static List<ValueLabel> departments = [
    ValueLabel(
      label: "BCA",
      value: "BCA",
    ),
    ValueLabel(
      label: "BSC",
      value: "BSC",
    ),
    ValueLabel(
      label: "Bcom Computer Application",
      value: "Bcom Computer Application",
    ),
    ValueLabel(
      label: "Food Technology",
      value: "Food Technology",
    ),
  ];
  static List<ValueLabel> departmentsFilter = [
    ValueLabel(
      label: "All",
      value: "All",
    ),
    ValueLabel(
      label: "BCA",
      value: "BCA",
    ),
    ValueLabel(
      label: "BSC",
      value: "BSC",
    ),
    ValueLabel(
      label: "Bcom Computer Application",
      value: "Bcom Computer Application",
    ),
    ValueLabel(
      label: "Food Technology",
      value: "Food Technology",
    ),
  ];
  static List<ValueLabel> subjects = [
    ValueLabel(
      label: "English",
      value: "English",
    ),
    ValueLabel(
      label: "Maths",
      value: "Maths",
    ),
    ValueLabel(
      label: "Computer",
      value: "Computer",
    ),
    ValueLabel(
      label: "RDBMS",
      value: "RDBMS",
    ),
  ];
  static List<ValueLabel> semesters = [
    ValueLabel(
      label: "1st Semester",
      value: "1",
    ),
    ValueLabel(
      label: "2st Semester",
      value: "2",
    ),
    ValueLabel(
      label: "3st Semester",
      value: "3",
    ),
    ValueLabel(
      label: "4st Semester",
      value: "4",
    ),
    ValueLabel(
      label: "5st Semester",
      value: "5",
    ),
    ValueLabel(
      label: "6st Semester",
      value: "6",
    ),
  ];
  static List<ValueLabel> teachersRole = [
    ValueLabel(
      label: "Head of Department",
      value: "HOD",
    ),
    ValueLabel(
      label: "Assistant Professor",
      value: "Assistant Professor",
    ),
    ValueLabel(
      label: "Teacher",
      value: "Teacher",
    ),
  ];

  static List<ValueLabel> courses = [
    ValueLabel(
      label: "BCA",
      value: "BCA",
    ),
    ValueLabel(
      label: "BSC",
      value: "BSC",
    ),
    ValueLabel(
      label: "Bcom Computer Application",
      value: "Bcom Computer Application",
    ),
    ValueLabel(
      label: "Food Technology",
      value: "Food Technology",
    ),
  ];
  static List<ValueLabel> yearOfAdmission = [
    ValueLabel(
      label: "2022",
      value: "2022",
    ),
    ValueLabel(
      label: "2023",
      value: "2023",
    ),
    ValueLabel(
      label: "2024",
      value: "2024",
    ),
    ValueLabel(
      label: "2024",
      value: "2024",
    ),
  ];
}
