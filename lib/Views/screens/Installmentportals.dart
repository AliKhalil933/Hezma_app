import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Views/screens/payment_page.dart';
import 'package:hezmaa/cubits/orders_cubit/mack_order_cubit.dart';
import 'package:hezmaa/cubits/orders_cubit/mackorder_state.dart';

class Installmentportals extends StatelessWidget {
  final double grandTotal;
  final String couponCode;
  final int? addressId;
  final int? timeId;
  final String date;
  final double shipping;
  final String userName;
  final String bankName;

  const Installmentportals({
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/Rectangle 70.png'),
            const SizedBox(height: 30),
            Image.asset('assets/images/Rectangle 71.png'),
            const SizedBox(height: 20),
            const SizedBox(height: 120),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: 155,
                    child: BlocBuilder<MakeOrderCubit, OrderStateOfMakeOrder>(
                      builder: (context, state) {
                        if (state is OrderLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ElevatedButton(
                          onPressed: () => _onSendButtonPressed(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'الدفع',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'STVBold',
                              fontSize: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'مجموع السعر',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'STVBold',
                        ),
                      ),
                      Text(
                        '${grandTotal.toStringAsFixed(2)} ر.س',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'STVBold',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSendButtonPressed(BuildContext context) {
    final makeOrderCubit = context.read<MakeOrderCubit>();

    // طباعة القيم
    print('Coupon Code: $couponCode');
    print('Payment Method ID: 2');
    print('Address ID: $addressId');
    print('Time ID: $timeId');
    print('Date: $date');
    print('Shipping: $shipping');
    print('User Name: $userName');
    print('Bank Name: $bankName');

    makeOrderCubit
        .makeOrder(
      couponCode: couponCode,
      paymentMethodId: 2,
      addressId: addressId!,
      timeId: timeId!,
      date: date,
      shipping: shipping,
      userName: userName,
      bankName: bankName,
    )
        .then((_) {
      _showCustomCenteredSnackBar(context, 'تم إرسال الطلب بنجاح');
      // الانتقال إلى صفحة الدفع
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PaymentPage()),
      );
    }).catchError((error) {
      _showCustomCenteredSnackBar(context, 'فشل في إرسال الطلب: $error');
    });
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'STVBold',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    height: 1.5,
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
}
