import 'package:flutter/material.dart';
import 'package:otp_verification/Screens/SignIn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(child: const SignIn()),
    );
  }
}


