import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Emails/siginup.dart';
import 'package:hezmaa/Views/screens/PrivacyPolicyPage.dart';
import 'package:hezmaa/Views/screens/forget_password.dart';
import 'package:hezmaa/cubits/Auth_cubt/Auth_serves_login.dart';
import 'package:hezmaa/cubits/Auth_cubt/login_cubit.dart';
import 'package:hezmaa/cubits/Auth_cubt/login_state.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/widgets/custom_navation_bar.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isEmailSelected = true;
  String? phoneNumberError;
  late TextEditingController _emailOrPhoneController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailOrPhoneController = TextEditingController();
    _passwordController = TextEditingController();
    _checkIfLoggedIn();
  }

  Future<void> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token != null) {
      // إذا كان التوكن موجودًا، تحقق من صحته
      final authService = AuthService();
      bool isValidToken = await authService.isLoggedIn();
      if (isValidToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CustomBottomNavigationBar(),
          ),
        );
      } else {
        await authService.logout();
      }
    }
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleSelection(bool isEmail) {
    setState(() {
      isEmailSelected = isEmail;
      _emailOrPhoneController.clear();
    });
  }

  void _validatePhoneNumber(PhoneNumber number) {
    setState(() {
      phoneNumberError = (number.countryISOCode == 'SA' &&
              number.completeNumber.startsWith('+966'))
          ? null
          : 'يرجى إدخال رقم سعودي صحيح';
    });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            'خطأ',
            style: TextStyle(
                color: Color(backgroundcolor2),
                fontFamily: 'STVBold',
                fontSize: 30),
          ),
        ),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'موافق',
              style: TextStyle(
                fontFamily: 'STVBold',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(backgroundcolor2),
      ),
      backgroundColor: const Color(backgroundcolor2),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 80, top: 30),
              child: SizedBox(
                height: 250,
                width: 250,
                child: Image.asset(
                  'assets/images/Logo Hezma.png',
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 290),
              child: Image.asset('assets/images/Rectangle 4.png'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 310, left: 80, right: 60),
                  child: Image.asset('assets/images/log.png'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildToggleButton(
                        text: 'البريد الالكتروني',
                        isSelected: isEmailSelected,
                        onPressed: () => _toggleSelection(true),
                      ),
                      const SizedBox(width: 20),
                      _buildToggleButton(
                        text: 'رقم الجوال',
                        isSelected: !isEmailSelected,
                        onPressed: () => _toggleSelection(false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: isEmailSelected
                      ? _buildTextField(
                          controller: _emailOrPhoneController,
                          hintText: 'البريد الالكتروني',
                          prefixIcon: Icons.email,
                        )
                      : _buildPhoneField(),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildTextField(
                    controller: _passwordController,
                    hintText: 'الرقم السري',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _navigateToForgotPassword,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'هل نسيت كلمة السر؟',
                        style: TextStyle(
                          fontFamily: 'STVBold',
                          fontSize: 15,
                          color: Color(0xff6C6262),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildPrivacyPolicySection(),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginFailure) {
                      _showErrorDialog(state.error);
                      print("Login failed with error: ${state.error}");
                    } else if (state is LoginSuccess) {
                      print(
                          "Login success! Saving login data and navigating...");
                      _saveLoginData(
                        _emailOrPhoneController.text.trim(),
                        _passwordController.text,
                        isEmailSelected,
                        state.token,
                      ).then((_) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CustomBottomNavigationBar(),
                            ),
                          );
                        });
                      }).catchError((e) {
                        print('Error while saving login data: $e');
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          final cubit = context.read<LoginCubit>();
                          cubit.loginUser(
                            emailOrPhone: _emailOrPhoneController.text.trim(),
                            password: _passwordController.text,
                            isEmail: isEmailSelected,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(380, 60),
                          backgroundColor: const Color(backgroundcolor2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'الدخول',
                          style: TextStyle(
                            color: Color(backgroundcolor1),
                            fontFamily: 'STVBold',
                            fontSize: 20,
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'هل أنت جديد في حزمة؟',
                      style: TextStyle(
                        fontFamily: 'STVBold',
                        fontSize: 16,
                        color: Color(0XFF6C6262),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SiginUpPage();
                        }));
                      },
                      child: const Text(
                        'انشاء حساب',
                        style: TextStyle(
                          fontFamily: 'STVBold',
                          color: Colors.green,
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        _showLoginDialog(context); // استدعاء الحوار هنا
                      },
                      child: const Text(
                        'الدخول بدون حساب',
                        style: TextStyle(
                          fontFamily: 'STVBold',
                          color: Colors.green,
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'يرجى تسجيل الدخول',
            style: TextStyle(
              fontFamily: 'STVBold',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'للاستمرار، يرجى تسجيل الدخول أو الاستمرار بدون حساب.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // استكمل التصفح
                      Navigator.of(context).pop(); // أغلق الحوار
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CustomBottomNavigationBar(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'استكمل التصفح',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // اذهب إلى صفحة تسجيل الدخول
                      Navigator.of(context).pop(); // أغلق الحوار
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage(), // استبدل LoginPage باسم صفحتك لتسجيل الدخول
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? const Color(backgroundcolor2)
              : const Color(backgroundcolor1),
          border: Border.all(
            width: 1,
            color: isSelected
                ? const Color(backgroundcolor1)
                : const Color(backgroundcolor2),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'STVBold',
              fontSize: 18,
              color: isSelected
                  ? const Color(backgroundcolor1)
                  : const Color(backgroundcolor2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        fontFamily: 'STVBold',
        fontSize: 20,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'STVBold',
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(backgroundcolor2),
        ),
        // إضافة الحدود الافتراضية
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Colors.transparent, // استخدام شفاف هنا
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Colors.green,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Color(backgroundcolor2),
          ),
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return IntlPhoneField(
      controller: _emailOrPhoneController,
      initialCountryCode: 'SA',
      decoration: InputDecoration(
        hintText: 'رقم الجوال',
        hintStyle: const TextStyle(
          fontFamily: 'STVBold',
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        // إضافة الحدود الافتراضية
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Colors.transparent, // استخدام شفاف هنا
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Colors.green,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Color(backgroundcolor2),
          ),
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onChanged: _validatePhoneNumber,
    );
  }

  Widget _buildPrivacyPolicySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PrivacyPolicyPage();
              }));
            },
            child: const Text(
              'سياسة الخصوصية',
              style: TextStyle(
                fontFamily: 'STVBold',
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ),
          const Text(
            'بإستخدامك لتطبيق حزمة فإنك توافق على',
            style: TextStyle(
              fontFamily: 'STVBold',
              fontSize: 12,
              color: Color(0xff6C6262),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveLoginData(
    String emailOrPhone,
    String password,
    bool isEmail,
    String token,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailOrPhone', emailOrPhone);
    await prefs.setString('password', password);
    await prefs.setBool('isEmail', isEmail);
    await prefs.setString('authToken', token);
  }
}
