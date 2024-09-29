import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hezmaa/Services/get_distractis.dart';
import 'package:hezmaa/models/districts/model_of_distractis.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/geocoding.dart';

class PageMap extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng) onSelectLocation;

  const PageMap(
      {Key? key, this.initialLocation, required this.onSelectLocation})
      : super(key: key);

  @override
  _PageMapState createState() => _PageMapState();
}

class _PageMapState extends State<PageMap> {
  late CameraPosition _initialCameraPosition;
  late GoogleMapController _mapController;
  Marker? selectedMarker;
  LatLng? _selectedLocation;
  static const LatLng centerOfRiyad = LatLng(24.7136, 46.6753);
  Set<Circle> _circles = {};
  final DistrictService _districtService = DistrictService();
  TextEditingController searchController = TextEditingController();

  final GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyBnwBzLrpcFsg31Ydigi73X7oL_L05hJB0');
  final GoogleMapsGeocoding _geocoding =
      GoogleMapsGeocoding(apiKey: 'AIzaSyBnwBzLrpcFsg31Ydigi73X7oL_L05hJB0');

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: widget.initialLocation ?? centerOfRiyad,
      zoom: 12,
    );
    _setDistrictCircles();
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

  // دالة البحث باستخدام Geocoding API
  Future<void> _searchLocation(String query) async {
    try {
      final response = await _geocoding.searchByAddress(query);
      if (response.results.isNotEmpty) {
        final location = response.results.first.geometry.location;
        final LatLng searchedLocation = LatLng(location.lat, location.lng);

        // تحريك الكاميرا إلى الموقع الجديد
        _mapController.animateCamera(
          CameraUpdate.newLatLng(searchedLocation),
        );

        // تحديث الماركر بالموقع الجديد
        _setMarker(searchedLocation);
      }
    } catch (e) {
      print('Error searching location: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // دالة لتحويل LatLng إلى عنوان باستخدام Geocoding API
  Future<String?> _getAddressFromLatLng(LatLng position) async {
    try {
      final response = await _geocoding.searchByLocation(
        Location(lat: position.latitude, lng: position.longitude),
      );
      if (response.results.isNotEmpty) {
        return response.results.first.formattedAddress;
      }
    } catch (e) {
      print('Error getting address: $e');
    }
    return null;
  }

  // تحديث الماركر مع اسم المكان بناءً على LatLng
  void _setMarker(LatLng position) async {
    String? address = await _getAddressFromLatLng(position);
    setState(() {
      _selectedLocation = position;
      selectedMarker = Marker(
        markerId: MarkerId('selected_location'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: address ?? 'الموقع المحدد', // عرض اسم المكان إذا كان متاحاً
        ),
      );
    });
  }

  void _moveToCurrentLocation() async {
    LatLng? currentLocation = await _getCurrentLocation();

    if (currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(currentLocation),
      );
      _setMarker(currentLocation);
    } else {
      _showCustomErrorDialog();
    }
  }

  Future<LatLng?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  bool _isLocationInRiyadh(LatLng location) {
    // Define Riyadh's bounding box (approximate)
    const double minLat = 24.5;
    const double maxLat = 25.0;
    const double minLng = 46.4;
    const double maxLng = 46.9;

    return location.latitude >= minLat &&
        location.latitude <= maxLat &&
        location.longitude >= minLng &&
        location.longitude <= maxLng;
  }

  void _showCustomErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ'),
          content: Text('الموقع المحدد خارج منطقة الرياض.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('موافق'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الموقع'),
          content: Text('هل أنت متأكد من هذا الموقع؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                confirmLocation();
              },
              child: Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  void confirmLocation() {
    if (_selectedLocation != null) {
      bool isInsideAnyCircle = false;

      // تحقق إذا كان الموقع داخل إحدى الدوائر
      for (Circle circle in _circles) {
        final double distance = Geolocator.distanceBetween(
          _selectedLocation!.latitude,
          _selectedLocation!.longitude,
          circle.center.latitude,
          circle.center.longitude,
        );

        if (distance <= circle.radius) {
          isInsideAnyCircle = true;
          break;
        }
      }

      if (isInsideAnyCircle) {
        // إذا كان داخل منطقة الدوائر
        widget.onSelectLocation(_selectedLocation!);
        Navigator.pop(context);
      } else {
        // إذا كان خارج منطقة الدوائر
        _showCustomErrorDialog();
      }
    } else {
      // إذا لم يتم اختيار موقع بعد
      _showCustomErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: _onMapCreated,
            onTap: (LatLng position) {
              _setMarker(position);
              _mapController.animateCamera(
                CameraUpdate.newLatLng(position),
              );
            },
            markers: selectedMarker != null ? {selectedMarker!} : {},
            circles: _circles, // إضافة الدوائر إلى الخريطة
          ),
          Positioned(
            top: 40.0,
            left: 15.0,
            right: 15.0,
            child: Row(
              children: [
                GestureDetector(
                  onTap: _moveToCurrentLocation,
                  child: Container(
                    width: 48,
                    height: 48,
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF00FF00), Color(0xFF007F00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'البحث عن موقع',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'STVBold',
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 13, horizontal: 8),
                          border: InputBorder.none,
                          prefixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              _searchLocation(searchController.text);
                            },
                          ),
                        ),
                        onSubmitted: (query) {
                          _searchLocation(query);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: () => _showConfirmationDialog(),
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'تأكيد الموقع',
                      style: TextStyle(
                        fontSize: 14, // تصغير حجم النص
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
