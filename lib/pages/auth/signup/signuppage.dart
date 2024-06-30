import 'package:flutter/material.dart';
import 'package:personal_finance_app/constants/constants.dart';
import 'package:personal_finance_app/models/user/user_dao.dart';
import 'package:personal_finance_app/pages/auth/login/loginpage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _scKey = GlobalKey<ScaffoldState>();
  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (password == confirmPassword) {
        try {
          await UsersDao().insertUser(name, email, password);

          _formKey.currentState!.reset();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords are doesn\'t match'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scKey,
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
                    'Join Us!',
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
                          'Name',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty || value.trim().length <= 2) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            name = newValue!;
                          },
                        ),
                        sizedBoxHeight(20),
                        Text(
                          'Email address',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
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
                          obscureText: obscureTextPass,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureTextPass = !obscureTextPass;
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
                        sizedBoxHeight(20),
                        Text(
                          'Confirm Password',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextFormField(
                          obscureText: obscureTextConfirmPass,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureTextConfirmPass =
                                        !obscureTextConfirmPass;
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
                            confirmPassword = newValue!;
                          },
                        ),
                      ],
                    ),
                  ),
                  sizedBoxHeight(40),
                  GestureDetector(
                    onTap: signUp,
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
                          'Sign Up',
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
                      const Text('Have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
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
