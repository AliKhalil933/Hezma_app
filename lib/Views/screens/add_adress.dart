import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hezmaa/Services/get_distractis.dart';
import 'package:hezmaa/cubits/adress_cubit/CreateAdressCubit.dart';
import 'package:hezmaa/cubits/adress_cubit/getAdressCubit.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/models/districts/model_of_distractis.dart'; // Ensure this file defines `arabicstyle2` and `backgroundcolor2`

class CreateAddressScreen extends StatefulWidget {
  const CreateAddressScreen({super.key});

  @override
  State<CreateAddressScreen> createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends State<CreateAddressScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  static const LatLng centerOfmansoura = LatLng(24.7136, 46.6753);
  String? _address;
  Set<Circle> _circles = {};
  final DistrictService _districtService = DistrictService();

  @override
  void initState() {
    super.initState();
    _selectedLatLng = centerOfmansoura;
    _setDistrictCircles();
  }

  void _onTap(LatLng latlng) async {
    setState(() {
      _selectedLatLng = latlng;
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String formattedAddress =
          "${place.street}, ${place.locality}, ${place.country}";
      setState(() {
        _address = formattedAddress;
      });
    }

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 12.0),
      ),
    );
  }

  Future<void> _setDistrictCircles() async {
    try {
      List<modelOfDistractis> districts =
          await _districtService.fetchDistricts();
      setState(() {
        _circles = districts.map((district) {
          return Circle(
            circleId: CircleId('district_circle_${district.id}'),
            center: LatLng(district.latitude, district.longitude),
            radius: 5000, // 5 كيلومتر
            fillColor: Colors.green.withOpacity(0.3),
            strokeColor: Colors.green,
            strokeWidth: 2,
          );
        }).toSet();
      });
    } catch (e) {
      print('Failed to load districts: $e');
    }
  }

  bool _isLatLngInsideAnyCircle(LatLng latLng) {
    for (Circle circle in _circles) {
      double distance = _calculateDistance(
        latLng.latitude,
        latLng.longitude,
        circle.center.latitude,
        circle.center.longitude,
      );
      if (distance <= circle.radius) {
        return true;
      }
    }
    return false;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371e3; // Earth's radius in meters
    final double lat1Rad = lat1 * (pi / 180);
    final double lat2Rad = lat2 * (pi / 180);
    final double deltaLat = (lat2 - lat1) * (pi / 180);
    final double deltaLon = (lon2 - lon1) * (pi / 180);

    final double a = (sin(deltaLat / 2) * sin(deltaLat / 2)) +
        (cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2));
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = R * c;

    return distance;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'تعديل العنوان',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'STVBold',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(17),
                ),
                child: TextField(
                  textAlign: TextAlign.end,
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "قم بتسميه العنوان مثال (المنزل. العمل)",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Container(
                height: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                ),
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onTap: _onTap,
                  initialCameraPosition: CameraPosition(
                    target: centerOfmansoura,
                    zoom: 10.0,
                  ),
                  markers: _selectedLatLng != null
                      ? {
                          Marker(
                            position: _selectedLatLng!,
                            infoWindow: InfoWindow(
                              title: _address ?? 'unknown',
                            ),
                            markerId: const MarkerId('selected-address'),
                          ),
                        }
                      : {},
                  circles: _circles,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocListener<CreateAddressCubit, CreateAddressState>(
                listener: (context, state) {
                  if (state is CreateAddressSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                    GoRouter.of(context).pop();
                  } else if (state is CreateAddressFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                child: GestureDetector(
                  onTap: () {
                    if (_selectedLatLng != null) {
                      if (_isLatLngInsideAnyCircle(_selectedLatLng!)) {
                        context.read<CreateAddressCubit>().createAddress(
                              name: nameController.text,
                              latitude: _selectedLatLng!.latitude.toString(),
                              longitude: _selectedLatLng!.longitude.toString(),
                              address: _address!,
                              districtId: 1, // Provide a valid districtId
                              distance: '0', // Provide a valid distance
                            );
                        context.read<GetAddressesCubit>().fetchAddresses();
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Center(
                                    child: const Text(
                                      'تنبيه',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'STVBold',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  content: Text(
                                    'هذا المكان خارج نطاق خدمتنا',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'STVBold',
                                      fontSize: 20,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'موافق',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontFamily: 'STVBold',
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("يرجى تحديد موقع على الخريطة")),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(backgroundcolor2),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Center(
                      child: Text('اضافه',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'STVBold',
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
