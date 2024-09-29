import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/cubits/cart_cubit/cart%20cubit2.dart';
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

class CustomCardOrder extends StatefulWidget {
  final ProdectModel prodact;
  final int quantity;

  const CustomCardOrder({
    super.key,
    required this.prodact,
    required this.quantity,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomCardOrderState createState() => _CustomCardOrderState();
}

class _CustomCardOrderState extends State<CustomCardOrder> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.quantity;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    context.read<CartManagementCubit>().addProductToCart(widget.prodact, 1);
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
        context
            .read<CartManagementCubit>()
            .addProductToCart(widget.prodact, -1);
      }
    });
  }

  double getTotalPrice() {
    double unitPrice = double.tryParse(widget.prodact.price ?? '0.0') ?? 0.0;
    return unitPrice * _counter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side: Location and City info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.green),
                        SizedBox(width: 5),
                        Text(
                          'الرياض, السعودية',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'STVBold',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.prodact.name ?? 'اسم المنتج',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'STVBold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'فاكهة', // Example product category
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        const SizedBox(width: 5),
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
            ),
            // Right side: Product image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Container(
                color: Colors.white,
                height: 100,
                width: 100,
                child: widget.prodact.image != null
                    ? Image.network(
                        widget.prodact.image!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
