import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


final GoogleSignIn googleSignIn = GoogleSignIn();

//Kayla's Contribution
class LoginPage extends StatefulWidget {

  final FirebaseAuth _auth;
  

  LoginPage({Key? key}) : _auth = FirebaseAuth.instance, super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

//Kayla's Contribution
class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context){

//Erick's Contribution
    return Scaffold(

        body: SingleChildScrollView(  //gets rid of overflow for scrolling
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              
               //use Spacer(), for spacing for all movile devices
                  //SPACING BETWEEN WIDGETS
                //SizedBox(
                    //height: 50,
                  //),
                  SizedBox(height: 30),

              
                  Image.asset('assets/images/image 6.png',
                    height: 200,
                    width: 200,
                  ), 
            
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
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      
                      ), 
                      hintStyle: TextStyle(color: Color.fromARGB(138, 135, 131, 131)), // Set the hint color to grey
                      filled: true,
                      fillColor: Colors.white,

                //Kayla's Contribution
                      suffixIcon: GestureDetector(
                      onTap: () {
                        _togglePasswordVisibility();
                      },
                      child: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                      
                      ),

                  //Erick's Contribution
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
                    _signInWithGoogle(context);
                    print('google clicked');
                    
                  }, child: Image.asset('assets/images/google.png',
                  width: 25,
                  height: 25,
                  
                  )),
                //----------------------------------------------- 
              SizedBox(height: 30),
              
                ],
              
              ),
            ),
          ),
      );
  }



//Kayla's Contribution
    void _togglePasswordVisibility() {
      setState(() {
        _isPasswordVisible = !_isPasswordVisible;
      });
    }


//Kayla's Contribution
void _signInWithGoogle(BuildContext context) async {
  try {
    // Attempt to sign in with Google
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in to Firebase with Google credentials
      final UserCredential userCredential = await widget._auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Navigate to the home page if authentication is successful
        Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      }
    }
  } catch (e) {
    // Handle authentication errors
    print('Error signing in with Google: $e');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to sign in with Google. Please try again later.'),
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

  void _signIn(BuildContext context) async {
  // Get user input from controllers
  String email = emailController.text;
  String password = passwordController.text;

  try {
    // Sign in with email and password
    var userCredential = await widget._auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Check if the user's email is verified
    if (userCredential.user != null && userCredential.user!.emailVerified) {
      // Navigate to the home page if authentication is successful
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    } else {
      // Email is not verified, show the popup
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Verify Your Email'),
          content: Text('You need to verify your email to continue. Please check your email inbox.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Optionally, redirect the user to the email verification page
                // Navigator.of(context).pushNamed('/verify-email');
              },
              child: Text('Later'),
            ),
            TextButton(
              onPressed: () {
                // Resend the verification email if necessary
                // await userCredential.user!.sendEmailVerification();
                // Redirect the user to the email verification page
                Navigator.of(context).pushReplacementNamed(AppRoutes.verify_email_page);

              },
              child: Text('Verify Email'),
            ),
          ],
        ),
      );
    }
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


