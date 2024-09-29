import 'package:flutter/material.dart';
import 'package:hezmaa/Services/get_wallet.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/wallet/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final TextEditingController _amountController = TextEditingController();
  late Future<Wallet?> _walletFuture;

  @override
  void initState() {
    super.initState();
    _walletFuture = _fetchWallet();
  }

  Future<Wallet?> _fetchWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token != null) {
      final walletFetchService = WalletFetchService();
      return await walletFetchService.fetchWallet(token);
    } else {
      print('No token found, please login first.');
      return null;
    }
  }

  Future<void> _chargeWallet() async {
    final String amount = _amountController.text.trim();

    if (amount.isEmpty) {
      _showMessage('يرجى إدخال قيمة الشحن');
      return;
    }

    try {
      _showMessage('تم شحن المحفظة بنجاح');
      setState(() {
        _walletFuture = _fetchWallet(); // تحديث بيانات المحفظة بعد الشحن
      });
    } catch (e) {
      _showMessage('حدث خطأ أثناء شحن المحفظة: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إضافة رصيد للمحفظة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'STVBold',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Wallet?>(
        future: _walletFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final wallet = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(backgroundcolor2),
                          Colors.green.shade700
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'رصيد المحفظة',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'STVBold',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${wallet?.balance ?? '0'} ريال',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'STVBold',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'قيمة الشحن',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.attach_money,
                          color: Color(backgroundcolor2)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _chargeWallet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(backgroundcolor2),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'الشحن',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'STVBold',
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'المعاملات',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'STVBold',
                    ),
                  ),
                  const SizedBox(height: 10),
                  // يمكن إضافة هنا قائمة المعاملات الخاصة بالمحفظة
                ],
              ),
            );
          } else {
            return Center(child: Text('لا يوجد بيانات.'));
          }
        },
      ),
    );
  }
}
