import 'dart:io';
import 'package:dog_food_app/services/auth.service.dart';
import 'package:dog_food_app/services/user.service.dart';
import 'package:dog_food_app/utils/index.dart';
import 'package:dog_food_app/views/auth/login.view.dart';
import 'package:dog_food_app/widgets/custom.filled.button.dart';
import 'package:dog_food_app/widgets/custom.input.field.dart';
import 'package:flutter/material.dart';
import 'package:dog_food_app/models/user.model.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  final String userEmail;

  const ProfileView({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final UserService _userService = UserService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  User? _user;
  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final user = await _userService.getUserByEmail(widget.userEmail);
      if (user != null) {
        setState(() {
          _user = user;
          _nameController.text = user.name;
          _addressController.text = user.address;
          _phoneController.text = user.phoneNumber ?? '';
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error loading user data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _updateProfile() async {
    if (_user == null) return;

    setState(() => _isLoading = true);
    try {
      String? imageUrl = _user!.imageUrl;

      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${_user!.email}.jpg');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      final updatedUser = _user!.copyWith(
        name: _nameController.text,
        address: _addressController.text,
        phoneNumber: _phoneController.text,
        imageUrl: imageUrl,
      );

      await _userService.updateUser(updatedUser);
      _showSuccessSnackBar('Profile updated successfully');
    } catch (e) {
      _showErrorSnackBar('Error updating profile');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (_user?.imageUrl != null
                              ? NetworkImage(_user!.imageUrl!)
                              : null) as ImageProvider?,
                      child: _image == null && _user?.imageUrl == null
                          ? const Icon(Icons.camera_alt, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    label: 'Name',
                    hint: 'Enter your name',
                    controller: _nameController,
                  ),
                  CustomInputField(
                    label: 'Email',
                    hint: 'Your email',
                    controller: TextEditingController(text: _user?.email ?? ''),
                    enabled: false,
                  ),
                  CustomInputField(
                    label: 'Address',
                    hint: 'Enter your address',
                    controller: _addressController,
                  ),
                  CustomInputField(
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    controller: _phoneController,
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Update Profile',
                    onPressed: _updateProfile,
                    loading: _isLoading,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Logout',
                    onPressed: () {
                      AuthService().signOut().then((value) => context.navigator(
                          context, const LoginView(),
                          shouldBack: false));
                    },
                    loading: _isLoading,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
    );
  }
}
