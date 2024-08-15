// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zigo_cloud_app/screens/login.dart';
import 'package:zigo_cloud_app/services/firebase_services.dart';
import 'package:zigo_cloud_app/services/my-app-method.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.title,
    required this.upperTitle,
    this.showLogoutButton =
        false, // قم بإضافة هذا المتغير لتحديد ما إذا كان الزر يظهر أم لا
  });

  final String title;
  final String upperTitle;
  final bool showLogoutButton; // استقباله كمتغير

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).shadowColor,
            Colors.deepPurple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // لتوزيع العناصر بالتساوي
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  upperTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (showLogoutButton)
              IconButton(
                onPressed: () {
                  MyAppMethod.showErrorWarning(
                      isError: false,
                      context: context,
                      subtitle: "Confirm logout",
                      function: () async {
                        await FirebaseService.logout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      });
                },
                icon: const Icon(CupertinoIcons.arrowshape_turn_up_left,
                    color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
