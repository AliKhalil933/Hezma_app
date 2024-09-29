import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Views/screens/order_page.dart';
import 'package:hezmaa/cubits/cart_cubit/cart%20cubit2.dart';
import 'package:hezmaa/cubits/orders_cubit/mack_order_cubit.dart';
import 'package:image_picker/image_picker.dart';

class Banktransfer extends StatefulWidget {
  final double grandTotal;
  final String couponCode;
  final int? addressId;
  final int? timeId;
  final String date;
  final double shipping;

  const Banktransfer({
    super.key,
    required this.grandTotal,
    required this.couponCode,
    this.addressId,
    this.timeId,
    required this.date,
    required this.shipping,
  });

  @override
  _BanktransferState createState() => _BanktransferState();
}

class _BanktransferState extends State<Banktransfer> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  String? receiptImagePath; // مسار صورة الإيصال
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 247, 245, 245),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'مؤسسة حزمة',
                      style: TextStyle(fontSize: 20, fontFamily: 'STVBold'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('اسم المحول'),
                  _buildEditableTextField(
                    userNameController,
                    'أدخل اسم المحول',
                    Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('اسم البنك'),
                  _buildEditableTextField(
                    bankNameController,
                    'أدخل اسم البنك',
                    Icons.account_balance,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('صورة الإيصال'),
                  _buildImageUpload(),
                ],
              ),
            ),
            const SizedBox(height: 120),
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
                    ElevatedButton(
                      onPressed: () {
                        _onSendButtonPressed(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
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
                          '${widget.grandTotal.toStringAsFixed(2)} ر.س',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'STVBold',
          ),
        ),
      ),
    );
  }

  Widget _buildEditableTextField(
      TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'STVBold',
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildImageUpload() {
    return GestureDetector(
      onTap: () async {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            receiptImagePath = pickedFile.path;
          });
        }
      },
      child: Container(
        width: double.infinity,
        height: 50,
        color: const Color.fromARGB(255, 206, 204, 204),
        child: Center(
          child: receiptImagePath == null
              ? const Icon(Icons.image, size: 30)
              : Image.file(
                  File(receiptImagePath!),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  void _onSendButtonPressed(BuildContext context) {
    final makeOrderCubit = context.read<MakeOrderCubit>();
    final cartCubit = context.read<CartManagementCubit>();

    if (userNameController.text.isEmpty ||
        bankNameController.text.isEmpty ||
        receiptImagePath == null) {
      _showCustomCenteredSnackBar(context, 'يرجى ملء جميع الحقول');
      return;
    }

    // طباعة البيانات التي سيتم إرسالها
    print('Sending order with the following data:');
    print('Coupon Code: ${widget.couponCode}');
    print('Payment Method ID: 1');
    print('Address ID: ${widget.addressId ?? -1}');
    print('Time ID: ${widget.timeId ?? -1}');
    print('Date: ${widget.date}');
    print('Shipping: ${widget.shipping}');
    print('User Name: ${userNameController.text}');
    print('Bank Name: ${bankNameController.text}');
    print('Receipt Image Path: $receiptImagePath');

    makeOrderCubit
        .makeOrder(
      couponCode: widget.couponCode,
      paymentMethodId: 1,
      addressId: widget.addressId ?? -1,
      timeId: widget.timeId ?? -1,
      date: widget.date,
      shipping: widget.shipping,
      userName: userNameController.text,
      bankName: bankNameController.text,
      image: receiptImagePath != null ? File(receiptImagePath!) : null,
    )
        .then((response) async {
      await cartCubit.clearCart();
      _showCustomCenteredSnackBar(context, 'لقد استلمنا طلبك');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrdersPage()),
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
