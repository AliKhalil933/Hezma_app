import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hezmaa/Services/get_distractis.dart';
import 'package:hezmaa/cubits/adress_cubit/EditAdressCubit.dart';
import 'package:hezmaa/cubits/adress_cubit/getAdressCubit.dart';
import 'package:hezmaa/adress/adress/modelAdress.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/models/districts/model_of_distractis.dart';
import 'dart:math';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({super.key, required this.place});
  final modelofAdress place;

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  GoogleMapController? _mapController1;
  LatLng? _selectedLatLng;
  late TextEditingController nameController;
  Set<Circle> _circles = {};
  final DistrictService _districtService = DistrictService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.place.name);
    _selectedLatLng = LatLng(
        double.parse(widget.place.lat!), double.parse(widget.place.lng!));
    _setDistrictCircles();
  }

  void _onTap(LatLng latLng) {
    setState(() {
      _selectedLatLng = latLng;
    });
    _mapController1?.animateCamera(CameraUpdate.newLatLng(latLng));
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
            radius: 5000, // 5 kilometers (adjust as needed)
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

  bool _isLatLngInsideCircle(LatLng latLng) {
    for (var circle in _circles) {
      final distance = _calculateDistance(
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'تعديل العنوان',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'STVBold',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
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
                    contentPadding: const EdgeInsets.all(10.0),
                    border: InputBorder.none,
                    hintStyle: const TextStyle(fontFamily: 'STVBold'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 400,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController1 = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _selectedLatLng!,
                  zoom: 12,
                ),
                markers: {
                  if (_selectedLatLng != null)
                    Marker(
                      markerId: const MarkerId('selectedLocation'),
                      position: _selectedLatLng!,
                      draggable: true,
                      onDragEnd: (latLng) {
                        setState(() {
                          _selectedLatLng = latLng;
                        });
                      },
                    ),
                },
                circles: _circles, // Pass the circles to the GoogleMap widget
                onTap: _onTap,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      _selectedLatLng != null) {
                    if (_isLatLngInsideCircle(_selectedLatLng!)) {
                      context.read<EditAddressCubit>().editAddress(
                            addressId: widget.place.id,
                            name: nameController.text,
                            address: widget.place.address,
                            latitude: _selectedLatLng!.latitude.toString(),
                            longitude: _selectedLatLng!.longitude.toString(),
                            districtId: 1, // Update with actual district ID
                            distance: '0', // Set or calculate as needed
                          );
                      context.read<GetAddressesCubit>().fetchAddresses();
                      GoRouter.of(context).pop();
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
                              child: Text('موافق',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontFamily: 'STVBold',
                                    fontSize: 20,
                                  )),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                      backgroundcolor2), // Use the button color from your constants
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: const Text(
                  'حفظ',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'STVBold',
                    fontSize: 20,
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
