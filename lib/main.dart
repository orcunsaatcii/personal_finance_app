import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/pages/auth/login/loginpage.dart';
import 'package:personal_finance_app/pages/home/page/page_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    return email != null && password != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          // While waiting for the future to complete, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If an error occurs, show an error message
          else if (snapshot.hasError) {
            return const Center(child: Text('Error checking login status'));
          }
          // Once the future completes, show the appropriate page
          else {
            if (snapshot.data == true) {
              return const PageManager();
            } else {
              return const LoginPage();
            }
          }
        },
      ),
    );
  }
}
