import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hezmaa/Views/screens/PrivacyPolicyPage.dart';
import 'package:hezmaa/Views/screens/TermsConditionsPage.dart';
import 'package:hezmaa/Views/screens/adress_page.dart';
import 'package:hezmaa/Views/screens/edite_Acc_page.dart';
import 'package:hezmaa/Views/screens/order_page.dart';
import 'package:hezmaa/Views/screens/support_page.dart';
import 'package:hezmaa/Views/screens/walit_page.dart';
import 'package:hezmaa/cubits/Auth_cubt/Auth_serves_login.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/helper/routes.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'حسابي',
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'STVBold',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                child: Image.asset(klogo),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildListTile(
                    context,
                    iconPath: 'assets/icons/user.png',
                    title: 'تعديل الحساب',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditAccountPage();
                      }));
                    },
                  ),
                  _buildListTile(
                    context,
                    iconPath: 'assets/icons/orders.png',
                    title: 'طلباتي',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return OrdersPage();
                          },
                        ),
                      );
                    },
                  ),
                  _buildListTile(
                    context,
                    iconPath: 'assets/icons/address.png',
                    title: 'العناوين',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddressPage();
                          },
                        ),
                      );
                    },
                  ),
                  _buildListTile(
                    context,
                    iconPath: 'assets/icons/pay.png',
                    title: 'المحفظة',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WalletPage();
                          },
                        ),
                      );
                    },
                  ),
                  _buildListTile(
                    context,
                    iconPath: 'assets/icons/help.png',
                    title: 'الدعم الفني',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SupportPage();
                          },
                        ),
                      );
                    },
                  ),
                  _buildListTile(
                    context,
                    iconPath: 'assets/icons/privacy.png',
                    title: 'سياسة الخصوصية',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const PrivacyPolicyPage();
                      }));
                    },
                  ),
                  _buildListTile(
                    context,
                    iconPath: 'assets/icons/terms.png',
                    title: 'الشروط والأحكام',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const TermsConditionsPage();
                      }));
                    },
                  ),
                  _buildListTile(
                    context,
                    iconPath: 'assets/icons/logout.png',
                    title: 'تسجيل الخروج',
                    onTap: () async {
                      final service = AuthService();
                      try {
                        await service.logout();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Row(
                                  children: [
                                    const Icon(Icons.exit_to_app,
                                        color: Colors.red),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'تسجيل الخروج',
                                      style: TextStyle(
                                        fontFamily: 'STVBold',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                content: const Text(
                                  'تم تسجيل خروجك بنجاح، شكراً!',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'STVBold',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'موافق',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      GoRouter.of(context)
                                          .pushReplacement(AppRoutes.log);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      } catch (e) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Row(
                                  children: [
                                    const Icon(Icons.error, color: Colors.red),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'خطأ',
                                      style: TextStyle(
                                        fontFamily: 'STVBold',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  'فشلت عملية تسجيل الخروج: ${e.toString()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'STVBold',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'موافق',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'STVBold',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String iconPath,
      required String title,
      required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Image.asset(
            iconPath,
            width: 30,
            height: 30,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'STVBold',
            ),
          ),
          trailing: const Icon(null),
          onTap: onTap,
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
