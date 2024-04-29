import 'package:flutter/material.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'dart:math';
import 'package:fluttermoji/fluttermojiSaveWidget.dart';
import 'package:fluttermoji/fluttermojiThemeData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserAvatar extends StatelessWidget {
  final double size;

  const UserAvatar({Key? key, this.size = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: Toolbar(title: "Customize AI"),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final userData = snapshot.data;
                  final avatarDetails = userData?['fluttermoji']; // Safe access with null-aware operator
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey[200],
                      child: SvgPicture.string(
                        FluttermojiFunctions()
                            .decodeFluttermojifromString(avatarDetails ?? ''),
                            fit: BoxFit.contain, // Ensure the SVG fits within the CircleAvatar
                            height: 160, // Specify the height to match the CircleAvatar size
                            width: 160, // Specify the width to match the CircleAvatar size
                          ),
                    ),
                  );
                },
              ),
              SizedBox(
                width: min(600, _width * 0.85),
                child: Row(
                  children: [
                    Text(
                      "Customize:",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Spacer(),
                    FluttermojiSaveWidget(
                      onTap: () async {
                        final value =
                            await FluttermojiFunctions().encodeMySVGtoString();
                        final userData = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .get();
                        final database = FirebaseFirestore.instance;

                        // Update the user's document with Fluttermoji data
                        await database.collection('users').doc(user.uid).update({
                          'fluttermoji': value,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Fluttermoji data saved!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: FluttermojiCustomizer(
                  scaffoldWidth: min(600, _width * 0.85),
                  autosave: false,
                  theme: FluttermojiThemeData(
                    boxDecoration: BoxDecoration(
                      boxShadow: [BoxShadow()],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
