import 'package:flutter/material.dart';
import 'package:hezmaa/Services/get_Pyment.dart';
import 'package:hezmaa/Views/screens/Banktransfer.dart';
import 'package:hezmaa/Views/screens/Electronicpayment.dart';
import 'package:hezmaa/Views/screens/Installmentportals.dart';
import 'package:hezmaa/Views/screens/payOnDelivery.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/payment_mesodes/payment/datum.dart';
import 'package:hezmaa/payment_mesodes/payment/payment.dart';

class PaymentHome extends StatefulWidget {
  final double grandTotal;
  final String couponCode;
  final int? addressId;
  final int? timeId;
  final String date;
  final double shipping;
  final String userName;
  final String bankName;

  const PaymentHome({
    super.key,
    required this.grandTotal,
    required this.couponCode,
    this.addressId,
    this.timeId,
    required this.date,
    required this.shipping,
    required this.userName,
    required this.bankName,
  });

  @override
  State<PaymentHome> createState() => _PaymentHomeState();
}

class _PaymentHomeState extends State<PaymentHome> {
  int _selectedButtonIndex = 0;
  final PageController _pageController = PageController();
  List<Datumpymant>? paymentMethods;
  bool isLoading = true;

  final PaymentService _paymentService = PaymentService();

  late final Map<String, Widget> _pagesMap;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pagesMap = {
      "apple_pay": Electronicpayment(),
      "bankTransferred": payOnDelivery(
        grandTotal: widget.grandTotal,
        couponCode: widget.couponCode,
        addressId: widget.addressId,
        timeId: widget.timeId,
        date: widget.date,
        shipping: widget.shipping,
        userName: widget.userName,
        bankName: widget.bankName,
      ),
      "payOnDelivery": Installmentportals(
        grandTotal: widget.grandTotal,
        couponCode: widget.couponCode,
        addressId: widget.addressId,
        timeId: widget.timeId,
        date: widget.date,
        shipping: widget.shipping,
        userName: widget.userName,
        bankName: widget.bankName,
      ),
      "visa": Banktransfer(
        grandTotal: widget.grandTotal,
        couponCode: widget.couponCode,
        addressId: widget.addressId,
        timeId: widget.timeId,
        date: widget.date,
        shipping: widget.shipping,
      ),
    };
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    Payment? payment = await _paymentService.getPaymentMethods();
    setState(() {
      paymentMethods = payment?.data;
      _setupPages();
      isLoading = false;
    });
  }

  void _setupPages() {
    _pages = [
      _pagesMap["payOnDelivery"] ?? Container(),
      _pagesMap["apple_pay"] ?? Container(),
      _pagesMap["bankTransferred"] ?? Container(),
      _pagesMap["visa"] ?? Container(),
    ];
  }

  void _onButtonPressed(int index) {
    setState(() {
      _selectedButtonIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'طريقة الدفع',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'STVBold',
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          List.generate(paymentMethods?.length ?? 0, (index) {
                        final method = paymentMethods![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton.icon(
                            onPressed: () => _onButtonPressed(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedButtonIndex == index
                                  ? const Color(0xff8DC245)
                                  : Colors.white,
                              minimumSize: const Size(150, 50),
                              side: const BorderSide(
                                  color: Color(backgroundcolor2)),
                            ),
                            icon:
                                method.image != null && method.image!.isNotEmpty
                                    ? Image.network(
                                        method.image!,
                                        height: 24,
                                        width: 24,
                                      )
                                    : const SizedBox.shrink(),
                            label: Text(method.name ?? ''),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedButtonIndex = index;
                      });
                    },
                    children: _pages,
                  ),
                ),
              ],
            ),
    );
  }
}
