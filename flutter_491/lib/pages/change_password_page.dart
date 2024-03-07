import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatelessWidget {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPasswordField(oldPasswordController, 'Old Password'),
            _buildPasswordField(newPasswordController, 'New Password'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _changePassword(context),
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }

  void _changePassword(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if user is signed in
        print(user);
        final credential = EmailAuthProvider.credential(email: user.email!, password: oldPasswordController.text);
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPasswordController.text);
        Navigator.pop(context, true); // Navigate back with success status
      } else {
        print('No user signed in');
        // Handle the case where no user is signed in
      }
    } catch (e) {
      print('Error changing password: $e');
      // Handle password change errors
    }
  }
}