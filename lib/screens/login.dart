// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:zigo_cloud_app/common/widgets/loading_holder.dart';
import 'package:zigo_cloud_app/common/widgets/top_bar.dart';
import 'package:zigo_cloud_app/main.dart';
import 'package:zigo_cloud_app/screens/home.dart';
import 'package:zigo_cloud_app/screens/sign_up.dart';
import 'package:zigo_cloud_app/services/firebase_services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await FirebaseService.login(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      print('Login success status: $success');

      if (!mounted) return;

      if (success) {
        print('Navigating to Home page...');
        await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Login Successful!'),
              content: const Text('You are now logged in.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                      (route) => false,
                    );
                  },
                  child: const Text('OK'),
                )
              ],
            );
          },
        );
      } else {
        print('Login failed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Login error: $e');
      debugPrint('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoadingHolder(
          isLoading: isLoading,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const TopBar(title: "Login", upperTitle: ''),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Log Into Your Account',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'example@domain.com',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: password,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: '********',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text("Don't have an account?"),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                MainApp.navigatorKey.currentState
                                    ?.push(MaterialPageRoute(
                                  builder: (ctx) => const SignUp(),
                                ));
                              },
                              child: const Text('Sign up'),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xff6D28D9), // Button color
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 25), // Padding inside the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Rounded corners
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState?.validate() ?? false) {
                                await login();
                              }
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
