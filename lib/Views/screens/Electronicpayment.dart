import 'package:flutter/material.dart';
import 'package:hezmaa/widgets/custom_buttons2.dart';
import 'package:hezmaa/widgets/custom_text_filed.dart';

class Electronicpayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'نقبل الدفع عن طريق',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'STVBold'),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Image.asset('assets/images/Group 1000007322.png'),
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  'رقم البطاقة',
                  style: TextStyle(fontFamily: 'STVBold'),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 8),
              customTexetFiled(
                text: 'رقم البطاقة',
                icon: Icon(Icons.credit_card),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  'الاسم المدون على البطاقة',
                  style: TextStyle(fontFamily: 'STVBold'),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 8),
              customTexetFiled(
                text: 'الاسم المدون على البطاقة',
                icon: Icon(Icons.credit_card),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  'تاريخ صلاحيات الكارت',
                  style: TextStyle(fontFamily: 'STVBold'),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: customTexetFiled(
                      text: 'شهر/سنة',
                      icon: Icon(Icons.calendar_today),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: customTexetFiled(
                      text: 'CVV',
                      icon: Icon(Icons.lock),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              CustomButon2(text: 'متابعة', color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
