import 'package:flutter/material.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة من الإشعارات (كمثال)
    final List<String> notifications = List<String>.generate(
      20,
      (index) => 'إشعار ${index + 1}: أهلا بيك في مؤسسة حزمة',
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'الاشعارات',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'STVBold'),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  const Icon(Icons.notification_important, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      notifications[index],
                      style:
                          const TextStyle(fontSize: 16, fontFamily: 'STVBold'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
