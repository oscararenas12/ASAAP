import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget{
  final FirebaseAuth _auth;
  LoginPage({Key? key}) : _auth = FirebaseAuth.instance, super(key: key);

   // Create TextEditingController for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context){

    return Scaffold(

        body: SingleChildScrollView(  //gets rid of overflow for scrolling
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding:EdgeInsets.all(24),
              child: Column(
                children: [
              
               //use Spacer(), for spacing for all movile devices
                  //SPACING BETWEEN WIDGETS
                //SizedBox(
                    //height: 50,
                  //),
                  Spacer(),

              
                  Text('ASAAPP', style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),),
              
              
                  Text('AI STUDENT ASSISTANT APP.'),
              
              
                  Text('HOME PAGE'),
            
                  SizedBox(
                    height: 30,
                  ),
              
                //TEXTFIELDS for username and password
            
                  Row(
                    children: [
                      Text('Email'),
                    ],
                  ),
            
                  SizedBox(
                    height: 10,
                  ),
            
                  TextField(
                    controller: emailController,
                    style: TextStyle(color: Color.fromARGB(137, 0, 0, 0)), //set textfield color to black
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      
                      ), 
                      hintStyle: TextStyle(color: Color.fromARGB(138, 135, 131, 131)), // Set the hint text color to grey
                      filled: true,
                      fillColor: Colors.white,
                      
                      ),
                  ),
              
                  SizedBox(
                    height: 20,
                  ),
            
                  Row(
                    children: [
                      Text('Password'),
                    ],
                  ),
            
                  SizedBox(
                    height: 10,
                  ),
              
                  TextField(
                    controller: passwordController,
                    style: TextStyle(color: Color.fromARGB(137, 0, 0, 0)), //set textfield color to black
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      
                      ), 
                      hintStyle: TextStyle(color: Color.fromARGB(138, 135, 131, 131)), // Set the hint color to grey
                      filled: true,
                      fillColor: Colors.white,
                      
                      ),
                      onEditingComplete: () {
                      // Call the signIn function when pressing "Enter" in the password field
                      _signIn(context);
                    },
                  ),
              
                SizedBox(
                  height: 20,
                ),
              
                //Login button
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(onPressed: (){
                    _signIn(context);
                  },
              
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
              
                  child: Text('Log In')),
                ),
              
                  
                SizedBox(
                  height: 20,
                ),
            
                //CREATE ACCOUNT button
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(onPressed: () {
                    print('create account clicked');
                    Navigator.of(context).pushReplacementNamed(AppRoutes.signup);
                  },
              
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
              
                  child: Text('Create Account')),
                ),
              
              
              
                  //Forgot password 
                  TextButton(onPressed: () {
                    print('Forgot clicked');
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  
                  child: Text('Forgot Password?')),
              
              
              
                //OPTIONAL - Sign in with different accounts
                  Text('Or sign in with',
                  style: TextStyle(
                    color: Colors.white,
                  ),),
              
                  ElevatedButton(onPressed: () {
                    print('google clicked');
                    
                  }, child: Image.asset('assets/images/google.png',
                  width: 25,
                  height: 25,
                  
                  )),
                //-----------------------------------------------

              
              Spacer(),
              
                ],
              
              ),
            ),
          ),
        )
      );
  }

   void _signIn(BuildContext context) async {
    // Get user input from controllers
    String email = emailController.text;
    String password = passwordController.text;

    try {
      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the home page if authentication is successful
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    } catch (e) {
      // Handle authentication errors
      print('Error signing in: $e');

      // Display an error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to sign in. Please check your credentials and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
