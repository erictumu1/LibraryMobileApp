import 'package:flutter/material.dart';
import 'package:library_front_end/Login/welcomescreen.dart';
import 'package:library_front_end/Provider/bookprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Firebase/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => BookProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Welcomescreen(),
      },
    );
  }
}
