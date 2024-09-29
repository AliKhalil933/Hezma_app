import 'package:flutter/material.dart';
import 'package:hezmaa/Services/get_order_detalis.dart';
import 'package:hezmaa/models/orderDetales/order_detales/ModelOfCartDedails.dart';
import 'package:hezmaa/models/orderDetales/order_detales/cart.dart';

class TrackingPage extends StatefulWidget {
  final int orderId;

  TrackingPage({required this.orderId});

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late Future<ModelcartDetails> _orderDetails;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _orderDetails = OrderDtailesServes().getOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'تتبع الطلب',
          style: TextStyle(fontFamily: 'STVBold'),
        ),
      ),
      body: FutureBuilder<ModelcartDetails>(
        future: _orderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('لا توجد بيانات للعرض'));
          } else {
            final orderDetails = snapshot.data!;
            final orderDate = orderDetails.orderDate;
            final orderTime = orderDetails.orderTime;
            final statusName = orderDetails.statusName;

            switch (orderDetails.status) {
              case 0:
                currentStep = 0; // استلام الطلب
                break;
              case 1:
                currentStep = 1; // تجهيز الطلب
                break;
              case 2:
                currentStep = 2; // توصيل الطلب
                break;
              case 3:
                currentStep = 3; // تسليم الطلب
                break;
              default:
                currentStep = 0;
                break;
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 290,
                      width: double.infinity,
                      child:
                          Image.asset('assets/icons/Group 1000007337 (1).png'),
                    ),
                  ),
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 241, 239, 239),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 60),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '(${orderDetails.orderId})',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'STVBold',
                                    color: Colors.green),
                              ),
                              Text(
                                'تتبع توصيل طلبك رقم ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'STVBold'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildOrderInfo(orderDate, 'تاريخ الطلب'),
                                    _buildOrderInfo(orderTime, 'وقت الطلب'),
                                    _buildOrderInfo(statusName, 'حالة الطلب'),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      orderTime ?? 'الوقت غير متوفر',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'STVBold',
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'بين الوقت',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'STVBold'),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      orderDate ?? '30.7.2024',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'STVBold',
                                          color: Colors.green),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      ':الوقت المتوقع للتوصيل',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'STVBold',
                                          color: Colors.black),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'المنتجات في الطلب:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'STVBold',
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orderDetails.cart.length,
                          itemBuilder: (context, index) {
                            final cartItem =
                                Cart.fromJson(orderDetails.cart[index]);
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Product Image
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: cartItem.product?.image != null
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    cartItem.product!.image!),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Product Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItem.product?.name ??
                                                'منتج غير متوفر',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'STVBold',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'السعر: ${cartItem.totalPrice} \$',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'الكمية: ${cartItem.quantity}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStep('استلام الطلب', 0),
                        _buildLine(),
                        _buildStep('تجهيز الطلب', 1),
                        _buildLine(),
                        _buildStep('توصيل الطلب', 2),
                        _buildLine(),
                        _buildStep('تسليم الطلب', 3, true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildStep(String text, int stepIndex, [bool isFinalStep = false]) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentStep = stepIndex;
        });
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.green,
                width: 3,
              ),
            ),
            child: Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: stepIndex <= currentStep ? Colors.green : Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'STVBold',
              color:
                  isFinalStep && currentStep == 3 ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine() {
    return Expanded(
      child: Container(
        height: 3,
        color: Colors.green,
      ),
    );
  }

  Widget _buildOrderInfo(String? info, String label) {
    return Column(
      children: [
        Text(
          info ?? 'غير متوفر',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'STVBold',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'STVBold',
          ),
        ),
      ],
    );
  }
}
