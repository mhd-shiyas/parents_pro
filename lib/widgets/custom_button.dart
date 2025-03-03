import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color_constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final double textSize;
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.bgColor = ColorConstants.primaryColor,
    this.borderColor = ColorConstants.primaryColor,
    this.textColor = Colors.white,
    this.textSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            width: 2,
            color: borderColor,
          )),
      onPressed: onTap,
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: textSize,
          color: textColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
