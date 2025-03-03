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
