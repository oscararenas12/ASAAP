import 'package:flutter/material.dart';

//app texts field in edit profile
///
class AppTextField extends StatelessWidget {
  final String hint;
  const AppTextField({super.key, required this.hint,});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint,
        labelStyle: TextStyle(
          color: Colors.white
        ),
        border: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),

        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        filled: true,
        fillColor: Color(0xff0D4393),
        
        ),
    );







    
  }
}