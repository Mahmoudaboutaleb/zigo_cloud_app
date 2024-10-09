import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // لإضافة Firebase
import 'package:zigo_cloud_app/utilis/location_service.dart'; // عدل الاسم حسب مشروعك

class MapScreen extends StatefulWidget {
  final String recipientID; // اضف معرف المستلم كمتغير

  const MapScreen(
      {super.key, required this.recipientID}); // تأكد من تمرير recipientID

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  LocationService locationService = LocationService();
  LatLng? otherUserLocation; // موقع المستخدم الآخر

  @override
  void initState() {
    super.initState();
    initialCameraPosition = const CameraPosition(
      target: LatLng(30.793009033588625, 30.989898601226464),
      zoom: 3.0,
    );
    getCurrentLocation();
    getOtherUserLocation(); // استدعاء موقع المستخدم الآخر
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        markers: markers,
        onMapCreated: (controller) {
          googleMapController = controller;
          updateCurrentLocation();
        },
        initialCameraPosition: initialCameraPosition,
      ),
    );
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Setting',
        onPressed: () {
          checkLocationPermission();
        },
      ),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> updateCurrentLocation() async {
    var uuid = const Uuid().v4();
    await locationService.checkAndRequestLocationService();
    bool locationPermission;

    if (mounted) {
      locationPermission =
          await locationService.checkAndRequestLocationPermission(context);

      if (locationPermission && mounted) {
        locationService.getRealTimeLocationData((locationData) async {
          if (mounted) {
            LatLng currentPosition =
                LatLng(locationData.latitude!, locationData.longitude!);

            // تحديث موقعك في Firebase
            await FirebaseFirestore.instance
                .collection('zigoAppUsers')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'location': {
                'latitude': locationData.latitude!,
                'longitude': locationData.longitude!,
              },
            });

            Marker locationMarker = Marker(
              markerId: MarkerId(uuid.toString()),
              position: currentPosition,
            );
            CameraPosition cameraPosition = CameraPosition(
              target: currentPosition,
              zoom: 9.0, // تغيير التكبير إلى 9 عند تحديد الموقع
            );
            setState(() {
              markers.clear(); // لتحديث الماركر وتجنب التداخل
              markers.add(locationMarker);
              if (otherUserLocation != null) {
                markers.add(
                  Marker(
                    markerId: const MarkerId('otherUser'),
                    position: otherUserLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue), // لون ماركر المستخدم الآخر
                  ),
                );
              }
              googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(cameraPosition),
              );
            });
          }
        }, context);
      } else {
        if (mounted) {
          showSnackbar("Location permission denied.");
        }
      }
    }
  }

  void getCurrentLocation() async {
    try {
      var location = await locationService.getLocation(context, mounted);
      if (location != null) {
        // التكبير هنا 9.0 عند تحديد الموقع
        CameraPosition myCurrentCameraPosition = CameraPosition(
            target: LatLng(location.latitude!, location.longitude!), zoom: 9.0);
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(myCurrentCameraPosition),
        );

        showSnackbar(
            "Current Location: ${location.latitude}, ${location.longitude}");
      }
    } catch (e) {
      showSnackbar("Error: ${e.toString()}");
    }
  }

  void checkLocationPermission() {
    locationService.checkAndRequestLocationPermission(context);
  }

  // جلب موقع المستخدم الآخر من Firebase
  Future<void> getOtherUserLocation() async {
    // جلب موقع المستخدم الآخر من Firebase
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('zigoAppUsers')
            .doc(widget.recipientID) // استخدم recipientID لجلب موقع الشخص الآخر
            .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data();
      if (data != null && data['location'] != null) {
        double latitude = data['location']['latitude'];
        double longitude = data['location']['longitude'];

        setState(() {
          otherUserLocation = LatLng(latitude, longitude);

          // إضافة الماركر على الخريطة لموقع المستخدم الآخر
          markers.add(Marker(
            markerId: const MarkerId('otherUserMarker'),
            position: otherUserLocation!,
          ));

          // تحديث الكاميرا لموقع المستخدم الآخر
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: otherUserLocation!,
                zoom: 9.0,
              ),
            ),
          );
        });
      }
    }
  }
}
