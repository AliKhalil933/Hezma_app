import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Services/adress_Get_ditales.dart';
import 'package:hezmaa/Views/screens/add_adress.dart';
import 'package:hezmaa/Views/screens/editeAdress.dart';
import 'package:hezmaa/adress/adress/modelAdress.dart';
import 'package:hezmaa/cubits/adress_cubit/DeletAdressCubit.dart';
import 'package:hezmaa/cubits/adress_cubit/getAdressCubit.dart';

class buildLocationSection extends StatefulWidget {
  const buildLocationSection({super.key});

  @override
  State<buildLocationSection> createState() => _buildLocationSectionState();
}

class _buildLocationSectionState extends State<buildLocationSection> {
  String selectedAddress = 'لم يتم اختيار عنوان بعد';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار عنوان التوصيل'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildLocationSection(),
      ),
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
              if (state is GetAddressesLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is GetAddressesSuccess) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'العناوين',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'STVBold',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.addresses.length,
                          itemBuilder: (context, index) {
                            final address = state.addresses[index];
                            return GestureDetector(
                              onTap: () {
                                _onAddressSelected(address);
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                padding: const EdgeInsets.all(16.0),
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
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditAddressScreen(
                                                  place: address,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _showDeleteConfirmationDialog(
                                                context, address.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
                          );
                        },
                        child: Text(
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
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<GetAddressesCubit>().fetchAddresses();
                        },
                        child: Text(
                          'تحديث',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'STVBold',
                            color: Colors.white,
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
              } else if (state is GetAddressesFailure) {
                return Center(child: Text(state.errorMessage));
              } else {
                return const Center(
                    child: Text(
                  'حدث خطأ غير متوقع',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'STVBold',
                    color: Colors.black54,
                  ),
                ));
              }
            },
          ),
        );
      },
    );
  }

  void _onAddressSelected(modelofAdress address) {
    setState(() {
      selectedAddress = address.name; // تحديث العنوان المحدد
    });
    Navigator.of(context).pop(); // إغلاق BottomSheet
  }

  void _showDeleteConfirmationDialog(BuildContext context, int addressId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'تأكيد الحذف',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'STVBold',
              color: Colors.black54,
            ),
          ),
          content: const Text(
            'هل أنت متأكد أنك تريد حذف هذا العنوان؟',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'STVBold',
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'STVBold',
                  color: Colors.black54,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<DelAddressCubit>().delAddresses(id: addressId);
                Navigator.of(context).pop();
              },
              child: const Text(
                'حذف',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'STVBold',
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
