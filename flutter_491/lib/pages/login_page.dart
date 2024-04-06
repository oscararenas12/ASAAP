import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_491/styles/app_colors.dart';
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
                      _resetPassword(context);
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
        content: Text(
            'Failed to sign in with Google.',
            style: TextStyle(color: Colors.black), // Set content text color to black
          ),
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

void _resetPassword(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController resetEmailController = TextEditingController();
      return AlertDialog(
        title: Text("Reset Password"),
        content: TextField(
          controller: resetEmailController,
          decoration: InputDecoration(hintText: "Enter your email"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String email = resetEmailController.text.trim();
              if (email.isNotEmpty) {
                try {
                  await widget._auth.sendPasswordResetEmail(email: email);
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Success'),
                      content: Text('Password reset email sent.',style: TextStyle(color: Colors.black),
                      ),
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
                } catch (e) {
                  print('Error resetting password: $e');
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text(
                        'Failed to reset password. Please try again later.',
                        style: TextStyle(color: Colors.black),
                      ),
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
            },
            child: Text('Reset'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}


  void _signIn(BuildContext context) async {
    // Get user input from controllers
    String email = emailController.text;
    String password = passwordController.text;

  try {
   
    // Sign in with email and password
    UserCredential userCredential = await widget._auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null && user.emailVerified) {
      // Navigate to the home page if authentication is successful and email is verified
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    } else if ( user != null && user.emailVerified == false){
      // Ask the user to verify their email
        showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 221, 244, 255), // Light blue background color for the dialog
        title: Text(
          'Email not verified',
          style: TextStyle(
            color: AppColors.lighterBlue, // The blue color we defined earlier
            fontWeight: FontWeight.bold, // Make the title text bold
          ),
        ),
        content: Text(
          'Please verify your email before signing in.',
          textAlign: TextAlign.center, // Center the content text
          style: TextStyle(
            color: AppColors.lighterBlue, // The blue color we defined earlier
          ),
        ),
        actionsAlignment: MainAxisAlignment.center, // Center the action buttons horizontally
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Later',
              style: TextStyle(color: AppColors.lighterBlue), // The blue color we defined earlier
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              // Redirect to verify email page
              Navigator.of(context).pushNamed(AppRoutes.verify_email_page);
            },
            child: Text(
              'Verify Email',
              style: TextStyle(color: AppColors.lighterBlue), // The blue color we defined earlier
            ),
          ),
        ],
      ),
    );
  }
  } on FirebaseAuthException catch (e) {
     String errorMessage;
    
    if (e.code == 'user-not-found') {
      errorMessage = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Wrong password provided for that user.';
    } else {
      errorMessage = 'An error occurred. Please try again.';
    }

    showDialog(
  context: context,
  builder: (context) => AlertDialog(
    backgroundColor: Color.fromARGB(255, 221, 244, 255), // Light blue background color for the dialog
    title: Text(
      'Login Error',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(255, 43, 106, 147), // Blue color from the logo
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Text(
      errorMessage, // Display the appropriate error message
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(255, 43, 106, 147), // Blue color from the logo
      ),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(
          'OK',
          style: TextStyle(color: Color.fromARGB(255, 43, 106, 147)), // Blue color from the logo
        ),
      ),
    ],
  ),
);

  }
}
}