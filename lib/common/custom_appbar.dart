import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parent_pro/constants/color_constants.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;
  final void Function()? onPressed;
  const CustomAppbar({
    super.key,
    required this.title,
    this.automaticallyImplyLeading = true,
    this.onPressed,
  });
  @override
  Size get preferredSize => const Size.fromHeight(70);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
      backgroundColor: ColorConstants.primaryColor,
      elevation: 0,
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: onPressed ?? () => Navigator.pop(context)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
