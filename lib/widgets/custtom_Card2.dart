import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/cubits/cart_cubit/cart%20cubit2.dart';
import 'package:hezmaa/home/home/product.dart';
import 'package:hezmaa/prodect/get_cart/prodact_of_carts.dart';

class CustomCard2 extends StatefulWidget {
  final ProdactModelsForCart cartItem;

  const CustomCard2({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  _CustomCard2State createState() => _CustomCard2State();
}

class _CustomCard2State extends State<CustomCard2> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = int.tryParse(widget.cartItem.quantity) ?? 1;
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    print('Counter incremented to $_counter');
    try {
      await context
          .read<CartManagementCubit>()
          .updateProductCount(widget.cartItem.cartId, _counter);
      _showCustomCenteredSnackBar(context, 'تم تحديث كمية المنتج في السلة');
    } catch (e) {
      _showCustomCenteredSnackBar(context, 'حدث خطأ، يرجى المحاولة مرة أخرى');
    }
  }

  void _decrementCounter() async {
    setState(() {
      if (_counter > 1) {
        _counter--;
      }
    });
    print('Counter decremented to $_counter');
    try {
      await context
          .read<CartManagementCubit>()
          .updateProductCount(widget.cartItem.cartId, _counter);
      _showCustomCenteredSnackBar(context, 'تم تحديث كمية المنتج في السلة');
    } catch (e) {
      _showCustomCenteredSnackBar(context, 'حدث خطأ، يرجى المحاولة مرة أخرى');
    }
  }

  double getTotalPrice() {
    double unitPrice =
        double.tryParse(widget.cartItem.product?.price ?? '0.0') ?? 0.0;
    return unitPrice * _counter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Quantity controls
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _decrementCounter,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                      ),
                      width: 30,
                      height: 30,
                      child: const Center(
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$_counter',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: _incrementCounter,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                      ),
                      width: 30,
                      height: 30,
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Center(
                      child: Text(
                        widget.cartItem.product?.name ??
                            'اسم المنتج غير متوفر', // Check if name is null
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'STVBold',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      widget.cartItem.product?.desc ??
                          'لا يوجد وصف', // Check if description is null
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontFamily: 'STVBold',
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'ر.س',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'STVBold',
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        getTotalPrice().toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'STVBold',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Product image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                ),
                height: 116,
                width: 130,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.cartItem.product?.image !=
                          null // Check if image is null
                      ? Image.network(
                          widget.cartItem.product!.image!,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: Colors.grey,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
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
