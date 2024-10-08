// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zigo_cloud_app/common/static.dart';
import 'package:zigo_cloud_app/screens/home.dart';
import 'package:zigo_cloud_app/screens/login.dart';
import 'package:zigo_cloud_app/services/firebase_services.dart';

/// 1.1.1 define a navigator key
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.setupFirebase();
  final prefs = await SharedPreferences.getInstance();
  final String? email = prefs.getString(FirebaseService.EMAIL);
  final String? password = prefs.getString(FirebaseService.PASSWORD);

  print('Stored email: $email');
  print('Stored password: $password');

  // تسجيل الدخول إذا كان البريد الإلكتروني وكلمة المرور موجودين
  if (email != null && password != null) {
    final success =
        await FirebaseService.login(email: email, password: password);
    if (success) {
      print('User logged in successfully');
    } else {
      print('Failed to log in user');
    }
  }

  print('Current User at startup: ${FirebaseService.currentUser?.toJson()}');

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  if (FirebaseService.currentUser != null) {
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: Statics.appID,
      appSign: Statics.appSign,
      userID: FirebaseService.currentUser!.email,
      userName: FirebaseService.currentUser!.name,
      plugins: [ZegoUIKitSignalingPlugin()],
      config: ZegoCallInvitationConfig(),
    );

    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
  } else {
    print('No user is currently logged in.');
  }

  runApp(MyApp(
    navigatorKey: navigatorKey,
    initialRoute:
        email != null && password != null ? const Home() : const Login(),
  ));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget initialRoute;

  const MyApp({
    required this.navigatorKey,
    required this.initialRoute,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Color(0xFF1C1030),
    ));

    const primaryColor = Color(0xFF351B5F);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: initialRoute,
    );
  }
}
