import 'package:flutter/material.dart';
import 'package:personal_finance_app/pages/auth/login/loginpage.dart';
import 'package:personal_finance_app/pages/home/page/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? email = sp.getString('email');

    setState(() {
      userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget initialPage =
        const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (userEmail == null) {
      initialPage = const LoginPage();
    } else {
      initialPage = const HomePage();
    }

    return MaterialApp(
      home: initialPage,
    );
  }
}
