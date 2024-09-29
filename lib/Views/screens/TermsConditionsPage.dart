import 'package:flutter/material.dart';
import 'package:hezmaa/Services/get_terms.dart';
import 'package:hezmaa/terms/terms/terms.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'الشروط والاحكام',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ),
      body: FutureBuilder<prodectModelTerms?>(
        future: TermsService().fetchTerms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final terms = snapshot.data;
            final termText = terms?.data?.isNotEmpty == true
                ? terms!.data!
                    .map((datum) =>
                        '${datum.name ?? 'بدون اسم'}: ${datum.value ?? 'بدون قيمة'}')
                    .join('\n\n')
                : 'لا توجد شروط متاحة.';
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                termText,
                textAlign: TextAlign.justify,
              ),
            );
          } else {
            return const Center(child: Text('لا توجد شروط متاحة.'));
          }
        },
      ),
    );
  }
}
