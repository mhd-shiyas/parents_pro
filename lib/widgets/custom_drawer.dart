import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parent_pro/constants/color_constants.dart';

class CustomDropdownWidget extends StatelessWidget {
  final String title;
  final String? value;
  final String hintText;
  final void Function(dynamic) onChanged;
  final List<DropdownMenuItem<Object>>? items;
  final String? Function(Object?)? validator;
  final bool isAutovalidate;
  const CustomDropdownWidget({
    super.key,
    required this.title,
    required this.value,
    this.hintText = "",
    required this.onChanged,
    required this.items,
    required this.validator,
    this.isAutovalidate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          //  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          height: validator != null ? 90 : 60,
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8),
          //     border: Border.all(color: const Color(0xff8892A1))),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              validator: validator,
              autovalidateMode: isAutovalidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              isExpanded: true,
              padding: EdgeInsets.zero,
              decoration: InputDecoration(
                hintStyle: GoogleFonts.montserrat(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xff8892A1))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: ColorConstants.primaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xff8892A1))),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
              hint: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: value,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
