import 'package:dog_food_app/models/user.model.dart';
import 'package:dog_food_app/services/auth.service.dart';
import 'package:dog_food_app/services/user.service.dart';
import 'package:dog_food_app/utils/index.dart';
import 'package:dog_food_app/views/auth/login.view.dart';
import 'package:dog_food_app/widgets/custom.filled.button.dart';
import 'package:dog_food_app/widgets/custom.input.field.dart';
import 'package:flutter/material.dart';
import 'package:dog_food_app/constants.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dogNameController = TextEditingController();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _dogNameController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _authService
            .signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        )
            .then((value) async {
          User user = User(
            name: _nameController.text,
            email: _emailController.text,
            address: _addressController.text,
            phoneNumber: _phoneNumberController.text,
          );
          await _userService.createUser(user);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
        context.navigator(context, const LoginView(), shouldBack: false);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                CustomInputField(
                  label: 'Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.lock),
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Address',
                  hint: 'Enter your address',
                  controller: _addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.home),
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  controller: _phoneNumberController,
                  inputType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.phone),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Sign Up',
                  onPressed: _signup,
                  loading: _isLoading,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Return to login screen
                  },
                  child: const Text(
                    "Already have an account? Log in",
                    style: TextStyle(color: secondoryGreen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
