import 'package:flutter/material.dart';
import 'package:hezmaa/Views/screens/everything.dart';
import 'package:hezmaa/Views/screens/favorite_page.dart';
import 'package:hezmaa/Views/screens/purchases_page.dart';
import 'package:hezmaa/Views/screens/setting.dart';
import 'package:hezmaa/helper/constants.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedIndex = 3;

  final List<Widget> screens = [
    const SettingPage(),
    IntroPage11(),
    FavoritesPage(),
    HomePage()
  ];

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          setState(() {
            selectedIndex = 3;
          });
          return false;
        },
        child: screens[selectedIndex],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          height: 75,
          color: const Color(0xff8DC245),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            currentIndex: selectedIndex,
            onTap: onItemTap,
            iconSize: 29,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'STVBold',
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontFamily: 'STVBold',
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'حسابى',
                backgroundColor: Color(backgroundcolor2),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'المشتريات',
                backgroundColor: Color(backgroundcolor2),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'المفضله',
                backgroundColor: Color(backgroundcolor2),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'الرئيسيه',
                backgroundColor: Color(backgroundcolor2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
