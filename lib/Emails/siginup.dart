import 'package:flutter/material.dart';
import 'package:hezmaa/Services/post_rigester.dart';
import 'package:hezmaa/Views/screens/otp_setting.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/widgets/CustomButon3.dart';
import 'package:hezmaa/widgets/CustomTexetFiled2.dart';
import 'package:hezmaa/widgets/custom-textfield3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SiginUpPage extends StatefulWidget {
  const SiginUpPage({super.key});

  @override
  _SiginUpPageState createState() => _SiginUpPageState();
}

class _SiginUpPageState extends State<SiginUpPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final prodectService = ProdectServiceDitelsRigester();
        final response = await prodectService.registerUser(
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
          password: passwordController.text,
          fcm:
              'd-G53x4dQCKm0IA3qS3cUb:APA91bFTsbA-ZQE-PF4v0hwUY-LV09ecPg9jjJrkJLAWPLavIxiMG5CDiF7XXHmc55bVpscMVDPLtnOVrvHACM__MDX5cDqVVgonhgtZXMVbJIMlegJThJ6nEoSKeO3rfefKv4z32kgH',
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('register_token', response.token ?? '');
        await prefs.setString('userName', response.name ?? '');
        await prefs.setString('userPhone', response.phone ?? '');
        await prefs.setString('userEmail', response.email ?? '');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم التسجيل بنجاح! مرحباً ${response.name}',
              style: const TextStyle(fontSize: 20, fontFamily: 'STVBold'),
            ),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IntroPage7(
              phoneNumber: response.phone ?? '',
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'فشل التسجيل: $e',
              style: const TextStyle(fontSize: 20, fontFamily: 'STVBold'),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى ملء الحقول المطلوبة بشكل صحيح.',
            style: TextStyle(fontSize: 20, fontFamily: 'STVBold'),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8DC245),
      ),
      backgroundColor: const Color(0xff8DC245),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              left: 90,
              top: 40,
              child: Container(
                height: 190,
                width: 190,
                child: Image.asset(
                  klogo,
                  color: const Color(backgroundcolor1),
                ),
              ),
            ),
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Image.asset('assets/images/Rectangle 4.png'),
            ),
            const Positioned(
              top: 290,
              left: 150,
              right: 60,
              child: Text(
                'تسجيل الدخول',
                style: TextStyle(fontSize: 20, fontFamily: 'STVBold'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 350, left: 5, right: 5),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTexetFiled2(
                      obscureText: false,
                      text: 'الاسم',
                      icon: null,
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTexetFiled2(
                      obscureText: false,
                      text: 'رقم الجوال',
                      icon: const Icon(Icons.phone),
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال رقم الجوال';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'أو',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff029445),
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTexetFiled2(
                      obscureText: false,
                      text: 'البريد الالكتروني',
                      icon: const Icon(Icons.mail),
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTexetFiled3(
                      text: 'الرقم السري',
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال الرقم السري';
                        }
                        return null;
                      },
                      onTapIcon: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      isPasswordVisible: _isPasswordVisible,
                    ),
                    const SizedBox(height: 10),
                    CustomTexetFiled3(
                      text: 'تأكيد الرقم السري',
                      controller: confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء تأكيد الرقم السري';
                        }
                        if (value != passwordController.text) {
                          return 'كلمات المرور غير متطابقة';
                        }
                        return null;
                      },
                      onTapIcon: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      isPasswordVisible: _isConfirmPasswordVisible,
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                ' سياسة الخصوصية',
                                style: TextStyle(
                                  fontFamily: 'STVBold',
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 1),
                              Text(
                                'بتسجيلك في حزمة فإنك توافق على ',
                                style: TextStyle(
                                  fontFamily: 'STVBold',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButon3(
                      onTap: _register,
                      text: 'تسجيل',
                      color: const Color(backgroundcolor2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
