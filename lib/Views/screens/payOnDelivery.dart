import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Views/screens/order_page.dart';
import 'package:hezmaa/cubits/cart_cubit/cart%20cubit2.dart';
import 'package:hezmaa/cubits/orders_cubit/mack_order_cubit.dart';
import 'package:hezmaa/cubits/orders_cubit/mackorder_state.dart';

class payOnDelivery extends StatelessWidget {
  final double grandTotal;
  final String couponCode;
  final int? addressId;
  final int? timeId;
  final String date;
  final double shipping;
  final String userName;
  final String bankName;

  const payOnDelivery({
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
        child: Column(
          children: [
            Image.asset('assets/images/Group 1000007380.png'),
            SizedBox(height: 90),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                                vertical: 10,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'ارسال',
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
                    BlocBuilder<MakeOrderCubit, OrderStateOfMakeOrder>(
                      builder: (context, state) {
                        if (state is OrderLoading) {
                          return CircularProgressIndicator();
                        }
                        return Column(
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
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSendButtonPressed(BuildContext context) async {
    final makeOrderCubit = context.read<MakeOrderCubit>();
    final cartCubit = context.read<CartManagementCubit>();

    // طباعة القيم
    print('Coupon Code: $couponCode');
    print('Payment Method ID: 3');
    print('Address ID: $addressId');
    print('Time ID: $timeId');
    print('Date: $date');
    print('Shipping: $shipping');
    print('User Name: $userName');
    print('Bank Name: $bankName');

    try {
      await makeOrderCubit.makeOrder(
        couponCode: couponCode,
        paymentMethodId: 3,
        addressId: addressId!,
        timeId: timeId!,
        date: date,
        shipping: shipping,
        userName: userName,
        bankName: bankName,
      );

      // مسح السلة بعد إتمام الطلب
      await cartCubit.clearCart();

      _showCustomCenteredSnackBar(context, 'لقد استلمنا طلبك');
      // الانتقال إلى صفحة الطلبات
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrdersPage()),
      );
    } catch (error) {
      _showCustomCenteredSnackBar(context, 'فشل في إرسال الطلب: $error');
    }
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/Group 1000007363.png',
                  width: 403,
                  height: 458,
                ),
              ],
            ),
          ),
        );
      },
    );
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
