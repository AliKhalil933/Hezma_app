import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hezmaa/Services/get_category.dart';
import 'package:hezmaa/Services/get_prodects.dart';
import 'package:hezmaa/Services/get_slider.dart';
import 'package:hezmaa/Views/screens/default_Screen.dart';
import 'package:hezmaa/Views/screens/page10.dart';
import 'package:hezmaa/Views/screens/navigation.dart';
import 'package:hezmaa/Views/screens/page_fruts.dart';
import 'package:hezmaa/Views/screens/page_vegetabols.dart';
import 'package:hezmaa/Views/screens/page_water.dart';
import 'package:hezmaa/cubits/Auth_cubt/Auth_serves_login.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/helper/routes.dart';
import 'package:hezmaa/home/home/slider.dart';
import 'package:hezmaa/models/category/prodactofCategoryModel.dart';
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';
import 'package:hezmaa/models/sliders/SlidersResponse.dart';
import 'package:hezmaa/widgets/custom_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<prodactofCategory>> _categoriesFuture;
  late Future<SlidersResponse> _slidersFuture;
  final PageController _pageController = PageController();
  Timer? _timer;

  List<SliderModel> sliders = [];

  @override
  void initState() {
    super.initState();
    final sliderService =
        SliderService(baseUrl: 'https://hezma-traning.eltamiuz.net');
    _slidersFuture = sliderService.fetchSliders();
    _categoriesFuture = categoryServeces().getcategory();

    _slidersFuture.then((response) {
      setState(() {
        sliders = response.data;
      });
    });

    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;

        if (sliders.isNotEmpty) {
          if (nextPage >= sliders.length) {
            nextPage = 0;
          }

          _pageController.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Center(
              child: Text(
                'هل تريد الخروج من التطبيق؟',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'STVBold',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 40,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 35),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'لا',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'STVBold',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton(
                  onPressed: () async {
                    final service = AuthService();
                    try {
                      await service.logout();
                      Navigator.of(context).pop(true);
                      _showCustomCenteredSnackBar(
                          context, 'تم تسجيل خروجك بنجاح، شكراً!');
                      GoRouter.of(context).pushReplacement(AppRoutes.log);
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'خطأ',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'STVBold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                                'فشلت عملية تسجيل الخروج: ${e.toString()}'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'موافق',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'STVBold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 35),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'نعم',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'STVBold',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _showCustomCenteredSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    if (overlay == null) {
      print('Overlay not found');
      return;
    }

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 11,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                        .sp, // Ensure you have the right setup for responsive font sizes
                    fontWeight: FontWeight.w400,
                    fontFamily: 'STVBold',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2))
        .then((_) => overlayEntry.remove());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: _buildNotificationButton(context),
          title: _buildTitle(),
          actions: [_buildOrderButton(context)],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSlidersSection(),
                  _buildCategoriesTitle(),
                  FutureBuilder<List<prodactofCategory>>(
                    future: _categoriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('حدث خطأ: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return _buildCategoriesRow(context, snapshot.data!);
                      } else {
                        return const Center(child: Text('لا توجد فئات متاحة.'));
                      }
                    },
                  ),
                  _buildProductsTitle(),
                ],
              ),
            ),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.notifications,
        color: Colors.green,
        size: 40,
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NavigationPage()));
      },
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          klogo,
          fit: BoxFit.contain,
          height: 100.h, // Responsive height
        ),
      ],
    );
  }

  Widget _buildOrderButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/icons/order.png',
        height: 40,
        width: 40,
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const IntroPage10()));
      },
    );
  }

  Widget _buildSlidersSection() {
    return FutureBuilder<SlidersResponse>(
      future: _slidersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final sliders = snapshot.data!.data;
          return Container(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: sliders.length,
              itemBuilder: (context, index) {
                final slider = sliders[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    slider.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, color: Colors.red);
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('لا توجد صور.'));
        }
      },
    );
  }
}

Widget _buildCategoriesTitle() {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: 18.w, vertical: 2.h), // Responsive padding
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'الاقسام',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp, // Responsive font size
            fontWeight: FontWeight.w400,
            fontFamily: 'STVBold',
          ),
        ),
      ],
    ),
  );
}

Widget _buildCategoriesRow(
    BuildContext context, List<prodactofCategory> categories) {
  return Center(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // تحديد الصفحات بناءً على الفئة
                Widget page;
                switch (category.name) {
                  case 'فاكهة':
                    page = const PageFruits();
                    break;
                  case 'مويه':
                    page = const PageWater();
                    break;
                  case 'خضار':
                    page = const PageVegetables();
                    break;
                  default:
                    page = const DefaultScreen();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              },
              child: Column(
                children: [
                  Card(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        category.image ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name ?? '',
                    style: const TextStyle(fontSize: 20, fontFamily: 'STVBold'),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

Widget _buildProductsTitle() {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: 18.w, vertical: 2.h), // Responsive padding
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'المنتجات',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp, // Responsive font size
            fontWeight: FontWeight.w400,
            fontFamily: 'STVBold',
          ),
        ),
      ],
    ),
  );
}

Widget _buildProductGrid() {
  return FutureBuilder<List<ProdectModel>>(
    future: ProdectService().getProdects(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError) {
        return SliverToBoxAdapter(
          child: Center(child: Text('حدث خطأ: ${snapshot.error}')),
        );
      } else if (snapshot.hasData) {
        List<ProdectModel> products = snapshot.data!;
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 3 / 4,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return CustomCard(product: products[index]);
            },
            childCount: products.length,
          ),
        );
      } else {
        return const SliverToBoxAdapter(
          child: Center(child: Text('لا توجد منتجات متاحة.')),
        );
      }
    },
  );
}
