import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hezmaa/cubits/profile_cubit/profile_cubit.dart';
import 'package:hezmaa/cubits/profile_cubit/profile_cubit_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    context.read<ProfileCubit>().fetchProfile();
    _loadImagePath();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveImagePath(String path) async {
    final state = context.read<ProfileCubit>().state;

    if (state is ProfileSuccess) {
      final userId = state.profile.id.toString();
    }
  }

  Future<void> _loadImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final state = context.read<ProfileCubit>().state;

    if (state is ProfileSuccess) {
      _nameController.text = state.profile.name ?? '';
      _phoneController.text = state.profile.phone ?? '';
      _emailController.text = state.profile.email ?? '';

      if (state.profile.image != null) {
        _selectedImage = File(state.profile.image!);
      }
    }
  }

  void _saveAccountDetails() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    context
        .read<ProfileCubit>()
        .updateProfile(
          name: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          password: _passwordController.text,
          image: _selectedImage,
        )
        .then((_) {
      context.read<ProfileCubit>().fetchProfile();
      Navigator.pop(context);
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _saveImagePath(pickedFile.path);
      context.read<ProfileCubit>().fetchProfile();
    }
  }

  ImageProvider<Object> getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage(
          'assets/icons/pngtree-faceless-male-profile-icon-png-image_4720958.png');
    }
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    return FileImage(File(imagePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'تعديل الحساب',
          style: TextStyle(fontFamily: 'STVBold'),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess && state.isProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حفظ التفاصيل بنجاح!')),
            );

            context.read<ProfileCubit>().fetchProfile();
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل في حفظ التفاصيل: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileSuccess) {
            _nameController.text = state.profile.name ?? '';
            _phoneController.text = state.profile.phone ?? '';
            _emailController.text = state.profile.email ?? '';
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.grey[300],
                          child: _selectedImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 150,
                                  ),
                                )
                              : ClipOval(
                                  child: Image(
                                    image: getImageProvider(
                                        state is ProfileSuccess
                                            ? state.profile.image
                                            : null),
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 150,
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'الاسم',
                    labelText: 'الاسم',
                    keyboardType: TextInputType.text,
                    iconPath: 'assets/icons/edit.png',
                  ),
                  _buildTextField(
                    controller: _phoneController,
                    hintText: 'رقم الجوال',
                    labelText: 'رقم الجوال',
                    keyboardType: TextInputType.phone,
                    iconPath: 'assets/icons/edit.png',
                  ),
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'البريد الإلكتروني',
                    labelText: 'البريد الالكتروني',
                    keyboardType: TextInputType.emailAddress,
                    iconPath: 'assets/icons/edit.png',
                  ),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'الرقم السري',
                    labelText: 'الرقم السري',
                    keyboardType: TextInputType.text,
                    iconPath: 'assets/icons/edit.png',
                    obscureText: true,
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.green,
                            width: 2.0,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const SizedBox(
                          height: 50,
                          width: 120,
                          child: Center(
                            child: Text(
                              'إلغاء',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontFamily: 'STVBold',
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed: _saveAccountDetails,
                        child: const SizedBox(
                          height: 50,
                          width: 120,
                          child: Center(
                            child: Text(
                              'حفظ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'STVBold',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required TextInputType keyboardType,
    required String iconPath,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(iconPath, height: 20, width: 20),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
