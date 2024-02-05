// signup_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_491/config/app_routes.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  bool _isPasswordVisible = false;


  Future<void> _createAccount() async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Save additional user information to Firestore
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'number': _numberController.text.trim(),
      // Add other fields as needed
    });

    print("Account created: ${userCredential.user!.email}");
    Navigator.of(context).pushNamed(AppRoutes.login);
  } on FirebaseAuthException catch (e) {
    print("Failed to create account: ${e.message}");
    // Handle errors based on the FirebaseAuthException code.
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
          // Add a back button to the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.login); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name', labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name', labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _numberController,
              decoration: InputDecoration(labelText: 'Number', labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: Colors.white),
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                ),
              ),
            ),
            
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createAccount,
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}