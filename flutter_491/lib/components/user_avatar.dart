import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {

  final double size;
  const UserAvatar({super.key,  this.size = 50});

  @override
  Widget build(BuildContext context) {

    //profile avatar
    return ClipRRect(  //image bordering
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Image.asset('assets/temp/User_cicrle.png',
      width: size,
      height: size,
      ),
    );
  }
}