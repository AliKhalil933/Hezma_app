import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hezmaa/Services/post_receved_otp.dart';
import 'package:hezmaa/Services/post_send_otp.dart';
import 'package:http/http.dart' as http;
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/widgets/custom_navation_bar.dart';
import 'package:hezmaa/widgets/textfield-otp.dart';

class IntroPage7 extends StatefulWidget {
  final String phoneNumber;

  const IntroPage7({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _IntroPage7State createState() => _IntroPage7State();
}

class _IntroPage7State extends State<IntroPage7> {
  int _seconds = 10;
  late Timer _timer;
  final TextEditingController c1 = TextEditingController();
  final TextEditingController c2 = TextEditingController();
  final TextEditingController c3 = TextEditingController();
  final TextEditingController c4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _sendOtp();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _sendOtp() async {
    try {
      final otpServices = OtpServicesSend();
      final result = await otpServices.sendOtp();

      if (result.containsKey('error')) {
        _showSnackBar(result['error']);
      } else {
        _showSnackBar('تم إرسال OTP: ${result['otp']}');
      }
    } catch (e) {
      _showSnackBar('خطأ: $e');
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _seconds = 10; // إعادة تعيين الوقت للتعداد العكسي
    });
    _startTimer();
    _sendOtp();
  }

  Future<void> _verifyCode() async {
    String smsCode = (c1.text) + (c2.text) + (c3.text) + (c4.text);

    if (smsCode.isEmpty || smsCode.length != 4) {
      _showSnackBar('يرجى إدخال رمز تحقق صحيح مكون من 4 أرقام');
      return;
    }

    try {
      final otpServices = OtpServicesReceived();
      final result = await otpServices.verifyOtp(smsCode);

      if (result.containsKey('error')) {
        _showSnackBar(result['error']);
      } else {
        _showSnackBar('تم التحقق بنجاح: ${result['message']}');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const CustomBottomNavigationBar();
        }));
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'STVBold',
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(backgroundcolor2),
      ),
      backgroundColor: const Color(backgroundcolor2),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Container(
              width: 229,
              height: 200,
              child: Image.asset(
                klogo,
                color: const Color(backgroundcolor1),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Rectangle 4.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 70, right: 60),
                        child: Image.asset('assets/images/tt.png'),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 11),
                        child: Image.asset('assets/images/00.png'),
                      ),
                      const SizedBox(height: 2),
                      Text('إرسال رمز التحقق إلى ${widget.phoneNumber}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'STVBold',
                            fontSize: 20,
                          )),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFiledOtp(
                              controller: c1, first: true, last: false),
                          TextFiledOtp(
                              controller: c2, first: false, last: false),
                          TextFiledOtp(
                              controller: c3, first: false, last: false),
                          TextFiledOtp(
                              controller: c4, first: false, last: false),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 350,
                        child: ElevatedButton(
                          onPressed: _seconds > 0 ? null : _resendCode,
                          child: Text(
                            _seconds > 0
                                ? 'إعادة إرسال كود التفعيل خلال ( $_seconds )'
                                : 'إعادة إرسال كود التفعيل',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'STVBold',
                              fontSize: 20,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _seconds > 0
                                ? Colors.grey
                                : const Color(backgroundcolor2),
                            elevation: 60,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: const Color(backgroundcolor2)),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 350,
                        child: ElevatedButton(
                          onPressed: _verifyCode,
                          child: const Text(
                            'تأكيد',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'STVBold',
                              fontSize: 20,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(backgroundcolor2),
                            elevation: 60,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: const Color(backgroundcolor2)),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
