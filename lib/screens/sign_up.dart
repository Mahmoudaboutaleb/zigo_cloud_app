// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:zigo_cloud_app/common/widgets/loading_holder.dart';
import 'package:zigo_cloud_app/common/widgets/top_bar.dart';
import 'package:zigo_cloud_app/screens/home.dart';
import 'package:zigo_cloud_app/services/firebase_services.dart';

class SignUp extends StatefulWidget {
  static const routeName = "/register";
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isSecure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final bool result = await FirebaseService.signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
      );
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => const Login()));
      if (result) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Registration Completed!'),
                content: const Text(
                    "You can log in with your email and password now!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                    },
                    child: const Text('OK'),
                  )
                ],
              );
            });
        if (mounted) Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong!")),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Signup error: $e');
      debugPrint('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoadingHolder(
          isLoading: _isLoading,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const TopBar(title: 'Sign up', upperTitle: ''),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Create a New Account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.length < 3) {
                            return 'Please enter a valid name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Username',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: _isSecure,
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isSecure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSecure = !_isSecure;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        icon: Icons.lock,
                        obscureText: _isSecure,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text("Already have an account?"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
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
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                            ),
                          ),
                          onPressed: _signUp,
                          child: const Text(
                            'Sign up',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
