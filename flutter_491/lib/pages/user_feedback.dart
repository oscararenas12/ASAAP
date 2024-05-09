import 'package:flutter/material.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // If using Firebase

class UserFeedbackPage extends StatefulWidget {
  @override
  _UserFeedbackPageState createState() => _UserFeedbackPageState();
}

class _UserFeedbackPageState extends State<UserFeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String _feedback = '';

  Future<void> _sendFeedback() async {
    if (_formKey.currentState!.validate()) {
      // If using Firebase, you could send the feedback like this:
      await FirebaseFirestore.instance.collection('feedback').add({
        'feedback': _feedback,
        'timestamp': FieldValue.serverTimestamp(), // Adds server-side timestamp
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thanks for your feedback!')),
      );

      // Clear the form
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        title: Text('User Feedback', style: AppText.header1),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Your Feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6, // Allows for multi-line input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some feedback';
                  }
                  return null;
                },
                onSaved: (value) {
                  _feedback = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendFeedback,
                child: Text('Submit Feedback', style: AppText.header2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkblue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
