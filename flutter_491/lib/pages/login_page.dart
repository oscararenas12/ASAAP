import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/pages/home_page.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});

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
                    style: TextStyle(color: Color.fromARGB(137, 0, 0, 0)), //set textfield color to black
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      
                      ), 
                      hintStyle: TextStyle(color: Color.fromARGB(138, 135, 131, 131)), // Set the hint color to grey
                      filled: true,
                      fillColor: Colors.white,
                      
                      ),
                  ),
              
                SizedBox(
                  height: 20,
                ),
              
                //Login button
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(onPressed: () {
                    //navigate to homepage
                    Navigator.of(context).pushReplacementNamed(AppRoutes.main);
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
}
