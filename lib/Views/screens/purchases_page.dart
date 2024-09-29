import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hezmaa/Services/adress_Get_ditales.dart';
import 'package:hezmaa/Views/screens/add_adress.dart';
import 'package:hezmaa/Views/screens/adress_page.dart';
import 'package:hezmaa/Views/screens/delevery_time.dart';
import 'package:hezmaa/Views/screens/editeAdress.dart';
import 'package:hezmaa/Views/screens/money.dart';
import 'package:hezmaa/adress/adress/modelAdress.dart';
import 'package:hezmaa/cubits/adress_cubit/DeletAdressCubit.dart';
import 'package:hezmaa/cubits/cart_cubit/cart%20cubit2.dart';
import 'package:hezmaa/cubits/cart_cubit/cart_cubit2State.dart';
import 'package:hezmaa/cubits/coupon_cubit/coubon_cubit.dart';
import 'package:hezmaa/cubits/adress_cubit/getAdressCubit.dart';
import 'package:hezmaa/home/home/product.dart';
import 'package:hezmaa/prodect/get_cart/prodact_of_carts.dart';
import 'package:hezmaa/widgets/custtom_Card2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IntroPage11 extends StatefulWidget {
  const IntroPage11({super.key});

  @override
  _IntroPage11State createState() => _IntroPage11State();
}

class _IntroPage11State extends State<IntroPage11> {
  final TextEditingController _couponController = TextEditingController();

  LatLng? selectedLocation;
  String selectedAddress = 'اختر عنوانًا';
  int? addressId;
  int? selectedTimeId;
  double shippingCost = 20;
  String userName = 'Ali';
  String bankName = 'Elahly';
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'السلة',
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'STVBold',
          ),
        ),
      ),
      body: BlocBuilder<CartManagementCubit, CartState2>(
        builder: (context, state) {
          // تحقق من وجود عناصر في السلة
          if (state.cartItems.isEmpty) {
            return Center(
                child: Text(
              'لا توجد عناصر في السلة.',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'STVBold',
                color: Colors.black54,
              ),
            ));
          }

          // تحقق من وجود عنوان محدد
          if (selectedAddress.isEmpty) {
            return Center(
                child: Text(
              'يرجى تحديد عنوان للتوصيل.',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'STVBold',
                color: Colors.black54,
              ),
            ));
          }

          double totalPrice = state.cartItems.fold(
            0.0,
            (sum, item) {
              final itemPrice =
                  double.tryParse(item.product?.price ?? '0.0') ?? 0.0;
              final quantity = int.tryParse(item.quantity ?? '0') ?? 0;
              return sum + (itemPrice * quantity);
            },
          );

          double tax = totalPrice * 0.15;
          double grandTotal = totalPrice + tax;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildCardList(state.cartItems),
                const SizedBox(height: 10),
                _buildLocationSection(),
                const SizedBox(height: 10),
                DeliveryTimeWidget(
                  onDateSelected: (date, timeId) {
                    setState(() {
                      selectedDate = date; // تأكد من تعيين التاريخ
                      selectedTimeId = timeId; // تأكد من تعيين وقت التوصيل
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildPaymentDetailsSection(
                  totalPrice: totalPrice,
                  tax: tax,
                  grandTotal: grandTotal,
                ),
                const SizedBox(height: 20),
                _buildPaymentButton(grandTotal: grandTotal),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardList(List<ProdactModelsForCart> cartItems) {
    return ListView.builder(
      itemCount: cartItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = cartItems[index];

        // Create a fallback product in case item.product is null
        final fallbackProduct = Product(
          id: 0, // Use a valid placeholder ID
          name: 'Default Name', // Default values
          desc: 'No description available',
          price: '0.0', // Default price
          image: '', // Default image URL or empty string
        );

        return Slidable(
          key: Key(item.cartId.toString()), // Use cartId for uniqueness
          startActionPane: ActionPane(
            motion: const StretchMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {
                context
                    .read<CartManagementCubit>()
                    .deleteProductFromCart(item.cartId);
              },
            ),
            children: [
              SlidableAction(
                onPressed: (context) {
                  context
                      .read<CartManagementCubit>()
                      .deleteProductFromCart(item.cartId);
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                icon: Icons.delete,
                label: 'حذف',
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: CustomCard2(
              cartItem: item, // Pass the entire cart item
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'حدد عنوان التوصيل',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'STVBold',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: _openAddressSelection,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedAddress.isEmpty ? 'اختر عنوانًا' : selectedAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'STVBold',
                      color: Colors.black54,
                    ),
                  ),
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _openAddressSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) =>
              GetAddressesCubit(AdressGetServes())..fetchAddresses(),
          child: BlocBuilder<GetAddressesCubit, GetAddressesState>(
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Text(
                        'العناوين',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'STVBold',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: state is GetAddressesLoading
                          ? const Center(child: CircularProgressIndicator())
                          : state is GetAddressesSuccess &&
                                  state.addresses.isNotEmpty
                              ? ListView.builder(
                                  itemCount: state.addresses.length,
                                  itemBuilder: (context, index) {
                                    final address = state.addresses[index];
                                    return Dismissible(
                                      key: Key(address.id
                                          .toString()), // Use a unique key for each item
                                      direction: DismissDirection
                                          .horizontal, // Allow swipe from both sides
                                      background: Container(
                                        color: Colors
                                            .red, // Background color for swipe from right
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      secondaryBackground: Container(
                                        color: Colors
                                            .red, // Background color for swipe from left
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: const Icon(Icons.delete,
                                            color: Colors.green),
                                      ),
                                      onDismissed: (direction) {
                                        // Call delete address function here
                                        context
                                            .read<DelAddressCubit>()
                                            .delAddresses(id: address.id)
                                            .then((_) {
                                          context
                                              .read<GetAddressesCubit>()
                                              .fetchAddresses(); // Refresh addresses
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                'تم حذف العنوان بنجاح'),
                                          ));
                                        });
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          _onAddressSelected(address);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          padding: const EdgeInsets.all(
                                              12.0), // Reduced padding for smaller size
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                8), // Slightly smaller border radius
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                address.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'STVBold',
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.green),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditAddressScreen(
                                                              place: address),
                                                    ),
                                                  ).then((_) {
                                                    context
                                                        .read<
                                                            GetAddressesCubit>()
                                                        .fetchAddresses(); // Auto-refresh after editing
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    state is GetAddressesFailure
                                        ? state.errorMessage
                                        : 'لا توجد عناوين متاحة.',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontFamily: 'STVBold',
                                    ),
                                  ),
                                ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAddressScreen(),
                          ),
                        ).then((_) {
                          context
                              .read<GetAddressesCubit>()
                              .fetchAddresses(); // Auto-refresh after adding
                        });
                      },
                      child: const Text(
                        'إضافة عنوان',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'STVBold',
                          color: Colors.black54,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        textStyle: const TextStyle(
                          fontFamily: 'STVBold',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onAddressSelected(modelofAdress address) {
    setState(() {
      selectedAddress = address.name;
      addressId = address.id;
    });
    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog(BuildContext context, int addressId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد أنك تريد حذف هذا العنوان؟'),
          actions: [
            TextButton(
              onPressed: () {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                context
                    .read<DelAddressCubit>()
                    .delAddresses(id: addressId)
                    .then((_) {
                  context.read<GetAddressesCubit>().fetchAddresses().then((_) {
                    Navigator.of(context).pop(); // Close loading indicator
                    Navigator.of(context).pop(); // Close confirmation dialog
                  });
                });
              },
              child: const Text('نعم'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation dialog
              },
              child: const Text('لا'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentDetailsSection({
    required double totalPrice,
    required double tax,
    required double grandTotal,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildPaymentDetailRow(
              '${totalPrice.toStringAsFixed(2)} ر.س', 'قيمة المنتجات'),
          const SizedBox(height: 8),
          _buildPaymentDetailRow(
              '${tax.toStringAsFixed(2)} ر.س', 'ضريبة القيمة المضافة 15%'),
          const Divider(color: Colors.grey),
          const SizedBox(height: 8),
          _buildPaymentDetailRow(
              '${grandTotal.toStringAsFixed(2)} ر.س', 'المجموع'),
          const SizedBox(height: 16),
          _buildApplyCouponSection(),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailRow(String amount, String description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          amount,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'STVBold',
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'STVBold',
          ),
        ),
      ],
    );
  }

  Widget _buildApplyCouponSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _couponController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'ادخل كوبون الخصم',
              hintStyle: const TextStyle(
                fontFamily: 'STVBold',
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            final couponCode = _couponController.text;
            if (couponCode.isNotEmpty) {
              context.read<CouponCubit>().verifyCoupon(couponCode);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                  'يرجى إدخال كوبون الخصم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'STVBold',
                  ),
                )),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              'تطبيق',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'STVBold',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton({required double grandTotal}) {
    return Padding(
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
              child: ElevatedButton(
                onPressed: () async {
                  // التحقق من الحقول
                  if (selectedAddress.isNotEmpty &&
                      selectedDate != null &&
                      selectedTimeId != null &&
                      userName.isNotEmpty &&
                      bankName.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentHome(
                          grandTotal: grandTotal,
                          couponCode: _couponController.text.isNotEmpty
                              ? _couponController.text
                              : '',
                          addressId: addressId,
                          timeId: selectedTimeId,
                          date: selectedDate!.toIso8601String(),
                          shipping: shippingCost,
                          userName: userName,
                          bankName: bankName,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('يرجى التأكد من تعبئة جميع الحقول')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
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
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Text(
                      ' ر.س',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'STVBold',
                      ),
                    ),
                    Text(
                      '${grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'STVBold',
                      ),
                    ),
                  ],
                ),
                const Text(
                  'المجموع شامل الضريبة',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'STVBold',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressPage()),
    );

    if (result != null && result is LatLng) {
      setState(() {
        selectedLocation =
            result; // Update the state with the selected location
      });
    }
  }
}
