import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async{
    showDialog(
      context: context,
      // barrierDismissible: false, //Prevents dialog from being dismissed by tapping outside.
      builder: (context){
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //Remove progress indicator
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      //Remove progress indicator
      Navigator.pop(context);

      //Wrong Email
      if (e.code == 'invalid-credential') {
        invalidCredentialsMessage();
      }

      //Wrong Password
      else if (e.code == 'invalid-email'){
        invalidEmailMessage();
      }
    }
  }

  void invalidCredentialsMessage() {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Error!', style: TextStyle(color: Colors.red,fontSize: 25),),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Invalid email or password',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Please check your credentials and try again.',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Ok',style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    },);
  }

  void invalidEmailMessage() {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Error!', style: TextStyle(color: Colors.red,fontSize: 25),),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Wrong Email Format',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Email must contail @',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Ok'),
          ),
        ],
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Icon(
                    Icons.library_books_rounded,
                    size: 100,
                    color: Colors.indigo[900],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 25, color: Colors.grey[900], fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.indigo[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.indigo[900],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or Continue with',
                          style: TextStyle(color: Colors.grey[900]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.indigo[900],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                      ),
                      child: Image.asset('lib/images/google.png', height: 50, width: 50),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                      ),
                      child: Image.asset('lib/images/apple.png', height: 50, width: 50),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New here?',
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Sign up today',
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
