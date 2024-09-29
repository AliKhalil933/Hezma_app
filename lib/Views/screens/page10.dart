import 'package:flutter/material.dart';
import 'package:hezmaa/Views/screens/fruts2.dart';
import 'package:hezmaa/Views/screens/vegetaols2.dart';
import 'package:hezmaa/Views/screens/water2.dart';

class IntroPage10 extends StatefulWidget {
  const IntroPage10({super.key});

  @override
  State<IntroPage10> createState() => _IntroPage10State();
}

class _IntroPage10State extends State<IntroPage10> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onButtonPressed(int index) {
    setState(() {
      _currentPage = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'كاتلوج حزمة',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'STVBold'),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('ماء', 0),
                const SizedBox(width: 20),
                _buildButton('فاكهة', 1),
                const SizedBox(width: 20),
                _buildButton('خضار', 2),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: const [
                water2(),
                fruts2(),
                vegatabols2()
                // أضف صفحة جديدة هنا، على سبيل المثال:
                // ThirdPage(),  // قم بإنشاء هذه الصفحة حسب الحاجة
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, int index) {
    return ElevatedButton(
      onPressed: _currentPage == index ? null : () => _onButtonPressed(index),
      style: ElevatedButton.styleFrom(
        foregroundColor: _currentPage == index ? Colors.white : Colors.green,
        backgroundColor: _currentPage == index ? Colors.green : Colors.white,
        minimumSize: const Size(100, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.green),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'STVBold',
          fontSize: 18,
        ),
      ),
    );
  }
}
