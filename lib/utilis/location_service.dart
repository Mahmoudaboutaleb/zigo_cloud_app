import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<void> checkAndRequestLocationService() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
  }

  Future<bool> checkAndRequestLocationPermission(BuildContext context) async {
    PermissionStatus permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
    }

    if (!context.mounted) return false;

    if (permissionStatus == PermissionStatus.deniedForever) {
      showSnackbar(
        "Permission permanently denied. Please enable it in settings.",
        context,
        Colors.red,
      );
    }

    if (permissionStatus == PermissionStatus.granted) {
      // showSnackbar(
      //   "Permission granted. You can access location.",
      //   context,
      //   Colors.green,
      // );
      return true;
    } else {
      showSnackbar("Permission not granted.", context, Colors.red);
      return false;
    }
  }

  void showSnackbar(String message, BuildContext context, Color color) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(
        message,
        style:
            const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<LocationData?> getLocation(BuildContext context, bool mounted) async {
    await checkAndRequestLocationService();

    if (!mounted) return null;

    bool permissionGranted = await checkAndRequestLocationPermission(context);

    if (mounted && permissionGranted) {
      return location.getLocation();
    }

    return null;
  }

  void getRealTimeLocationData(
      void Function(LocationData)? onData, BuildContext context) async {
    await checkAndRequestLocationService();

    if (!context.mounted) return;

    await checkAndRequestLocationPermission(context);

    if (!context.mounted) return;

    location.onLocationChanged.listen((LocationData locationData) {
      onData?.call(locationData);
    });
  }
}
