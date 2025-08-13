import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
import 'package:flutterflow_assesment/Screens/mainscreen/mainscreen.dart';
import 'package:flutterflow_assesment/firebase_options.dart';
// import 'package:flutterflow_assesment/json_uploader.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // // ✅ Run this ONCE to upload JSON
  // await uploadAllJsonFiles();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
