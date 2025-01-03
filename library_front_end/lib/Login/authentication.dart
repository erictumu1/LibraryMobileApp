import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_front_end/Read/homepage.dart';
import 'package:library_front_end/Login/login.dart';
import 'package:library_front_end/Read/librarianhomepage.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          // User logged in
          if (snapshot.hasData) {
            final user = snapshot.data!;
            final email = user.email;

            if (email != null) {
              if (email.endsWith('@staff.bayshore.ca')) {
                return const LibrarianHomepage();
              } else if (email.endsWith('@bayshore.ca')) {
                return const Homepage();
              } else {
                return const Center(
                  child: Text(
                    'Invalid email domain.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }
            }
          }

          // User not logged in
          return Login();
        },
      ),
    );
  }
}
