import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Views/screens/traching_page.dart';
import 'package:hezmaa/cubits/orders_cubit/order_canceld_cubit.dart';
import 'package:hezmaa/cubits/orders_cubit/order_cubit.dart';
import 'package:hezmaa/cubits/orders_cubit/order_state.dart';
import 'package:hezmaa/helper/constants.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final PageController _pageController = PageController(initialPage: 2);
  int _selectedTab = 2;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderCubit>(context).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'جميع الطلبات',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'STVBold',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTabButtons(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              children: [
                _buildPreviousOrders(),
                _buildCanceledOrders(),
                _buildCurrentOrders(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabButton('الطلبات الملغاة', 1),
          _buildTabButton('الطلبات السابقة', 0),
          _buildTabButton('الطلبات الحالية', 2),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedTab = index;
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: _selectedTab == index ? Colors.white : Colors.black,
        backgroundColor:
            _selectedTab == index ? Color(backgroundcolor2) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: Color(backgroundcolor2), width: 2),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'STVBold',
        ),
      ),
    );
  }

  Widget _buildCurrentOrders() {
    return BlocBuilder<OrderCubit, OrderStateOfOrder>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is OrderLoaded) {
          if (state.orders.isEmpty) {
            return Center(child: Text('لا توجد طلبات حالية'));
          }
          return ListView.builder(
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return _buildOrderCard(
                orderNumber: order.orderId,
                price: order.totalPrice,
                date: DateFormat('yyyy-MM-dd')
                    .format(DateTime.now()), // Today's date
                orderId: order.orderId,
              );
            },
          );
        } else if (state is OrderError) {
          return Center(child: Text('فشل في تحميل الطلبات: ${state.message}'));
        }
        return Center(child: Text('لا توجد طلبات حالية'));
      },
    );
  }

  Widget _buildOrderCard({
    required int orderNumber,
    required double price,
    required String date,
    required int orderId,
    bool isCanceledOrder =
        false, // Parameter to indicate if the order is canceled
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'رقم الطلب: $orderNumber#',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'STVBold',
                  ),
                ),
                Text(
                  'السعر: ${price.toStringAsFixed(0)} ريال',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'STVBold',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'التاريخ: $date',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'STVBold',
              ),
            ),
            SizedBox(height: 20),
            // Display buttons only if the order is not canceled
            if (!isCanceledOrder) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackingPage(orderId: orderId),
                        ),
                      );
                    },
                    child: Text(
                      'متابعة الطلب',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'STVBold',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(backgroundcolor2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<OrderCancelCubit>(context)
                          .cancelOrder(orderId)
                          .then((_) {
                        BlocProvider.of<OrderCubit>(context)
                            .fetchOrders(); // Ensure orders are updated

                        // Navigate to canceled orders
                        _showCustomCenteredSnackBar(
                            context, 'تم إلغاء الطلب بنجاح');
                      });
                    },
                    child: Text(
                      'إلغاء الطلب',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'STVBold',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousOrders() {
    return BlocBuilder<OrderCubit, OrderStateOfOrder>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is OrderLoaded) {
          // Logic to display previous orders
          final previousOrders = state.orders
              .where((order) => order.status == 'completed')
              .toList();
          if (previousOrders.isEmpty) {
            return Center(child: Text('لا توجد طلبات سابقة'));
          }
          return ListView.builder(
            itemCount: previousOrders.length,
            itemBuilder: (context, index) {
              final order = previousOrders[index];
              return _buildOrderCard(
                orderNumber: order.orderId,
                price: order.totalPrice,
                date: order.orderDate,
                orderId: order.orderId,
              );
            },
          );
        } else if (state is OrderError) {
          return Center(child: Text('فشل في تحميل الطلبات: ${state.message}'));
        }
        return Center(child: Text('لا توجد طلبات سابقة'));
      },
    );
  }

  Widget _buildCanceledOrders() {
    return BlocBuilder<OrderCubit, OrderStateOfOrder>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderLoaded) {
          final canceledOrders = state.canceledOrders;

          print('عدد الطلبات الملغاة: ${canceledOrders.length}');

          if (canceledOrders.isEmpty) {
            return const Center(child: Text('لا توجد طلبات ملغاة'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: canceledOrders.length,
                  itemBuilder: (context, index) {
                    final order = canceledOrders[index];
                    return _buildOrderCard(
                      orderNumber: order.orderId,
                      price: order.totalPrice,
                      date: DateFormat('yyyy-MM-dd')
                          .format(DateTime.now()), // تاريخ اليوم
                      orderId: order.orderId,
                      isCanceledOrder: true,
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is OrderError) {
          return Center(child: Text('فشل في تحميل الطلبات: ${state.message}'));
        }
        return Center(child: Text('لا توجد طلبات ملغاة'));
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
