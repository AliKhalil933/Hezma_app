import 'package:flutter/material.dart';
import 'package:hezmaa/Services/get_setting.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'سياسة الخصوصية',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'STVBold',
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: SettingService().fetchSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'لا توجد بيانات',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'STVBold',
              ),
            ));
          }

          final settings = snapshot.data!;
          final privacyPolicy = settings.firstWhere(
              (setting) => setting['name'] == 'usage_policy',
              orElse: () => {'value': 'سياسة الخصوصية غير متوفرة'})['value'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              privacyPolicy,
              textAlign: TextAlign.justify,
            ),
          );
        },
      ),
    );
  }
}
