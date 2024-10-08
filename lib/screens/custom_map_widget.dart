// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:uuid/uuid.dart';
// import 'package:zigo_cloud_app/utilis/location_service.dart'; // عدل الاسم حسب مشروعك

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late CameraPosition initialCameraPosition;
//   late GoogleMapController googleMapController;
//   Set<Marker> markers = {};
//   LocationService locationService = LocationService();

//   @override
//   void initState() {
//     super.initState();
//     initialCameraPosition = const CameraPosition(
//       target: LatLng(30.793009033588625, 30.989898601226464),
//       zoom: 3.0,
//     );
//     getCurrentLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     // عدل اسم المستخدم حسب مشروعك
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarIconBrightness: Brightness.light,
//       statusBarColor: Colors.transparent,
//     ));

//     return Scaffold(
//       body: GoogleMap(
//         zoomControlsEnabled: false,
//         markers: markers,
//         onMapCreated: (controller) {
//           googleMapController = controller;
//           updateCurrentLocation();
//         },
//         initialCameraPosition: initialCameraPosition,
//       ),
//     );
//   }

//   void showSnackbar(String message) {
//     final snackBar = SnackBar(
//       content: Text(message),
//       action: SnackBarAction(
//         label: 'setting',
//         onPressed: () {
//           checkLocationPermission();
//         },
//       ),
//       duration: const Duration(seconds: 3),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   Future<void> updateCurrentLocation() async {
//     var uuid = const Uuid().v4();
//     await locationService.checkAndRequestLocationService();
//     bool locationPermission;

//     if (mounted) {
//       locationPermission =
//           await locationService.checkAndRequestLocationPermission(context);

//       if (locationPermission && mounted) {
//         locationService.getRealTimeLocationData((locationData) {
//           if (mounted) {
//             LatLng currentPossition =
//                 LatLng(locationData.latitude!, locationData.longitude!);
//             Marker locationMarker = Marker(
//               markerId: MarkerId(uuid.toString()),
//               position: LatLng(locationData.latitude!, locationData.longitude!),
//             );
//             CameraPosition cameraPosition = CameraPosition(
//               target: currentPossition,
//               zoom: 12.0,
//             );
//             setState(() {
//               markers.clear(); // لتحديث الماركر وتجنب التداخل
//               markers.add(locationMarker);
//               googleMapController.animateCamera(
//                 CameraUpdate.newCameraPosition(cameraPosition),
//               );
//             });
//           }
//         }, context);
//       } else {
//         if (mounted) {
//           showSnackbar("Location permission denied.");
//         }
//       }
//     }
//   }

//   void getCurrentLocation() async {
//     try {
//       var location = await locationService.getLocation(context, mounted);
//       if (location != null) {
//         CameraPosition myCurrentCameraPosition = CameraPosition(
//             target: LatLng(location.latitude!, location.longitude!),
//             zoom: 12.0);
//         googleMapController.animateCamera(
//           CameraUpdate.newCameraPosition(myCurrentCameraPosition),
//         );

//         showSnackbar(
//             "Current Location: ${location.latitude}, ${location.longitude}");
//       }
//     } catch (e) {
//       showSnackbar("Error: ${e.toString()}");
//     }
//   }

//   void checkLocationPermission() {
//     locationService.checkAndRequestLocationPermission(context);
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // لإضافة Firebase
import 'package:zigo_cloud_app/utilis/location_service.dart'; // عدل الاسم حسب مشروعك

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

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
    // عند فتح التطبيق، تكون قيمة التكبير 2.0
    initialCameraPosition = const CameraPosition(
      target: LatLng(30.793009033588625, 30.989898601226464),
      zoom: 3.0, // التكبير 2 عند فتح التطبيق
    );
    getCurrentLocation();
    getOtherUserLocation(); // استدعاء موقع المستخدم الآخر
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
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
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc('OTHER_USER_UID') // استبدل بـ UID المستخدم الآخر
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('location')) {
          double latitude = userData['location']['latitude'];
          double longitude = userData['location']['longitude'];
          setState(() {
            otherUserLocation = LatLng(latitude, longitude);
          });
        }
      }
    } catch (e) {
      showSnackbar("Error fetching other user location: ${e.toString()}");
    }
  }
}
