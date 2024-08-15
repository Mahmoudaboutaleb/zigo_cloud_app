import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zigo_cloud_app/screens/login.dart';
import 'package:zigo_cloud_app/services/firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.setupFirebase();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 117, 73, 187)));
    const primaryColor = Color(0xff4338CA);
    const secondaryColor = Color(0xff6D28D9);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: primaryColor,
        shadowColor: secondaryColor,
      ),
      home: const Login(),
    );
  }
}
