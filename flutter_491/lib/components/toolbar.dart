import 'package:flutter/material.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';


//NAVIGATIO BAR

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const Toolbar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: AppColors.darkblue,
        title: Text(title, style: AppText.header1,
        ),

        actions: actions,
      );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(60);
}