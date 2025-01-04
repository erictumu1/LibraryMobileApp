import 'package:flutter/material.dart';
import 'package:library_front_end/Login/authentication.dart';
import 'login.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 5), () {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => Authentication()));
    // });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                elevation: 15,
                color: Colors.transparent,
                shape: CircleBorder(),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.library_books_rounded,
                      size: 100,
                      color: Colors.indigo[900],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Bayshore Library',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
      ),
    );
  }
}
