import 'package:flutter/material.dart';
import 'package:personal_finance_app/constants/constants.dart';
import 'package:personal_finance_app/models/user_dao.dart';
import 'package:personal_finance_app/pages/auth/signup/signuppage.dart';
import 'package:personal_finance_app/pages/home/page/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscureTextCheck = true;
  String email = '';
  String password = '';

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final sp = await SharedPreferences.getInstance();

      try {
        final isUserExists = await UsersDao().userExists(email, password);
        await sp.setString('email', email);
        if (mounted) {
          if (isUserExists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User not found'),
              ),
            );
          }
        }
      } catch (e) {
        e.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back!',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  sizedBoxHeight(50),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email address',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !value.trim().contains('@')) {
                              return 'Please enter valid email format';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            email = newValue!;
                          },
                        ),
                        sizedBoxHeight(20),
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextFormField(
                          obscureText: obscureTextCheck,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureTextCheck = !obscureTextCheck;
                                  });
                                },
                                icon: const Icon(Icons.remove_red_eye)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty || value.trim().length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            password = newValue!;
                          },
                        ),
                      ],
                    ),
                  ),
                  sizedBoxHeight(20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password?'),
                    ],
                  ),
                  sizedBoxHeight(20),
                  GestureDetector(
                    onTap: login,
                    child: Container(
                      width: double.infinity,
                      height: screenHeight * 0.08,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.pink,
                            Colors.blue,
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  sizedBoxHeight(20),
                  Row(
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Create a new one',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Colors.blue,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
