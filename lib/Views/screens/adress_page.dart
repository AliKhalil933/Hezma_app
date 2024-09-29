import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hezmaa/cubits/adress_cubit/CreateAdressCubit.dart';
import 'package:hezmaa/cubits/adress_cubit/DeletAdressCubit.dart';
import 'package:hezmaa/cubits/adress_cubit/getAdressCubit.dart';
import 'package:hezmaa/Views/screens/editeAdress.dart';
import 'package:hezmaa/Views/screens/page_map.dart';
import 'package:hezmaa/adress/adress/modelAdress.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:google_maps_webservice/geocoding.dart'; // مكتبة Geocoding

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  GoogleMapController? mapController;
  LatLng selectedLocation = LatLng(24.7136, 46.6753); // Default to Riyadh, KSA
  final TextEditingController searchController = TextEditingController();
  final GoogleMapsGeocoding _geocoding = GoogleMapsGeocoding(
      apiKey:
          'AIzaSyBnwBzLrpcFsg31Ydigi73X7oL_L05hJB0'); // ضع مفتاح الـ API الخاص بك هنا
  String? markerAddress;

  @override
  void initState() {
    super.initState();
    // Fetch addresses when the page loads
    context.read<GetAddressesCubit>().fetchAddresses();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _searchLocation(String query) async {
    try {
      final response = await _geocoding.searchByAddress(query);
      if (response.results.isNotEmpty) {
        final location = response.results.first.geometry.location;
        final LatLng searchedLocation = LatLng(location.lat, location.lng);

        // Move camera to the new location
        mapController?.animateCamera(
          CameraUpdate.newLatLng(searchedLocation),
        );

        // Update selected location and marker
        setState(() {
          selectedLocation = searchedLocation;
          markerAddress =
              response.results.first.formattedAddress; // Update marker address
        });
      } else {
        _showErrorDialog('لم يتم العثور على الموقع');
      }
    } catch (e) {
      _showErrorDialog('خطأ في البحث عن الموقع');
    }
  }

  Future<void> _updateMarkerAddress(LatLng position) async {
    try {
      // Use the Geocoding API to get the address from coordinates
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Check if we have placemarks
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        setState(() {
          markerAddress =
              '${placemark.name}, ${placemark.locality}, ${placemark.country}';
        });
      } else {
        setState(() {
          markerAddress = 'غير معروف';
        });
      }
    } catch (e) {
      setState(() {
        markerAddress = 'خطأ في استرجاع البيانات';
      });
    }
  }

  void saveLocation() {
    final newAddress = modelofAdress(
      id: 0, // Assuming the ID will be generated later
      name: markerAddress ?? 'الموقع المحدد', // Use the actual address here
      address: ' السعودية', // Placeholder if needed
      lat: selectedLocation.latitude.toString(),
      lng: selectedLocation.longitude.toString(),
      distance: '0', // Set distance or calculate as needed
    );

    // Check if the location is outside Riyadh
    if (selectedLocation.latitude < 24.5 ||
        selectedLocation.latitude > 25.5 ||
        selectedLocation.longitude < 46.0 ||
        selectedLocation.longitude > 47.5) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/Group 106 (1).png',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'الموقع المحدد خارج الرياض',
                    style: TextStyle(fontSize: 16, fontFamily: 'STVBold'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // Save the address
      context
          .read<CreateAddressCubit>()
          .createAddress(
            name: newAddress.name,
            address: newAddress.address,
            latitude: newAddress.lat,
            longitude: newAddress.lng,
            districtId: 1, // Replace with actual district ID
            distance: newAddress.distance,
          )
          .then((_) {
        // Refresh addresses after creation
        context.read<GetAddressesCubit>().fetchAddresses();
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(fontSize: 16, fontFamily: 'STVBold'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'العناوين',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'STVBold',
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color(0XFFF0F0F0),
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.green),
                    onPressed: () {
                      _searchLocation(searchController.text);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.right,
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'تحديد ع الخريطة',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'STVBold',
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'STVBold',
                        fontSize: 14,
                      ),
                      onSubmitted: (query) {
                        _searchLocation(query);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          BlocListener<GetAddressesCubit, GetAddressesState>(
            listener: (context, state) {
              if (state is GetAddressesSuccess) {
                // يمكنك تنفيذ أي إجراء إضافي هنا عند نجاح التحميل
              } else if (state is GetAddressesFailure) {
                _showErrorDialog(state.errorMessage);
              }
            },
            child: BlocBuilder<GetAddressesCubit, GetAddressesState>(
              builder: (context, state) {
                if (state is GetAddressesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is GetAddressesSuccess) {
                  return buildAddressCards(state.addresses);
                } else if (state is GetAddressesFailure) {
                  return Center(child: Text(state.errorMessage));
                }
                return Center(child: Text('لا توجد عناوين متاحة.'));
              },
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white, // Ensure the background color is set
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: selectedLocation,
                    zoom: 12,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('selectedLocation'),
                      position: selectedLocation,
                      draggable: true,
                      onDragEnd: (newPosition) {
                        setState(() {
                          selectedLocation = newPosition;
                        });
                        _updateMarkerAddress(
                            newPosition); // Update address on drag
                      },
                      infoWindow: InfoWindow(
                        title: markerAddress ?? 'الموقع المحدد',
                      ),
                    ),
                  },
                  onTap: (LatLng position) {
                    setState(() {
                      selectedLocation = position;
                      _updateMarkerAddress(position); // Update address on tap
                    });
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: const Border(
                  top: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.green, size: 32),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'العنوان المستخدم حالياً', // Current address label
                        style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'STVBold',
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        markerAddress ??
                            'الرحمانية، الرياض، السعودية', // Default or current address
                        style: TextStyle(
                          fontFamily: 'STVBold',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8), // Pushes the button to the bottom
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                backgroundColor:
                    Color(backgroundcolor2), // Ensure correct button color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageMap(
                      onSelectLocation: (LatLng location) {
                        setState(() {
                          selectedLocation = location;
                        });
                        saveLocation(); // Save location immediately
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                'اضافة موقع',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<GetAddressesCubit>().fetchAddresses();
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.green,
        tooltip: 'تحديث',
      ),
    );
  }

  Widget buildAddressCards(List<modelofAdress> addresses) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: addresses.map((address) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLocation = LatLng(
                    double.parse(address.lat), double.parse(address.lng));
                mapController
                    ?.animateCamera(CameraUpdate.newLatLng(selectedLocation));
              });
            },
            child: Card(
              elevation: 4,
              child: Container(
                width: 200,
                child: Column(
                  children: [
                    Icon(Icons.location_on, color: Colors.green),
                    Text(address.name),
                    Text(address.address),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditAddressScreen(
                                  place: address,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context
                                .read<DelAddressCubit>()
                                .delAddresses(id: address.id);
                            context.read<GetAddressesCubit>().fetchAddresses();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
