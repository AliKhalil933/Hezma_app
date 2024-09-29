import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:hezmaa/Services/get_prodects.dart';
import 'package:hezmaa/cubits/cart_cubit/cart%20cubit2.dart';

import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

import 'package:hezmaa/widgets/custom_card.dart';

class Intropage12 extends StatefulWidget {
  final int productId;
  final ProdectModel prodect;

  const Intropage12({
    Key? key,
    required this.productId,
    required this.prodect,
  }) : super(key: key);

  @override
  _Intropage12State createState() => _Intropage12State();
}

class _Intropage12State extends State<Intropage12> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  void _addToCart() {
    if (_counter > 0) {
      context
          .read<CartManagementCubit>()
          .addProductToCart(widget.prodect, _counter);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop(); // Close the dialog after 1 second
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
                    'assets/images/Group 106.png',
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'يرجى تحديد عدد العناصر أولا.',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  double rating = 2;

  double get totalPrice {
    double price = double.tryParse(widget.prodect.price!) ?? 0.0;
    return price * _counter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.network(widget.prodect.image!),
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Text(
                      widget.prodect.name ?? 'اسم المنتج',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'STVBold',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 130),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '$_counter',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            GestureDetector(
                              onTap: _incrementCounter,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(15),
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
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          PannableRatingBar(
                            textDirection: TextDirection.rtl,
                            rate: rating,
                            items: List.generate(
                              5,
                              (index) => const RatingWidget(
                                selectedColor: Colors.green,
                                unSelectedColor: Colors.grey,
                                child: Icon(
                                  Icons.star,
                                  size: 15,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                rating = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'ر.س/كجم',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'STVBold',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.prodect.price!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      'مزيد من التفاصيل',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontFamily: 'STVBold',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    widget.prodect.desc!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'STVBold',
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      'مزيد من المنتجات',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontFamily: 'STVBold',
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: FutureBuilder<List<ProdectModel>>(
                    future: ProdectService().getProdects(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ProdectModel> products = snapshot.data!;
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return CustomCard(
                              product: products[index],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                          'خطأ في جلب البيانات',
                          style: TextStyle(
                            fontFamily: 'STVBold',
                          ),
                        ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
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
                    child: ElevatedButton(
                      onPressed: _addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(backgroundcolor2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'اضف الي السلة',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'STVBold',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'مجموع السعر',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'STVBold',
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            ' ر.س',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'STVBold',
                            ),
                          ),
                          Text(
                            '${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(backgroundcolor2),
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              fontFamily: 'STVBold',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
