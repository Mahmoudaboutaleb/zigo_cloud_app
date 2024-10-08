// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:zigo_cloud_app/products/titleTextWidget.dart';

class MyAppMethod {
  static Future<void> showErrorWarning(
      {required BuildContext context,
      required String subtitle,
      required Function function,
      bool isError = true}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/warning.png",
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 20),
                TitleTextWidget(label: subtitle, fontSize: 20),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isError,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(46, 132, 49, 1)))),
                    ),
                    TextButton(
                        onPressed: () {
                          function();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Ok",
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  static Future<void> imagePickDialog({
    required BuildContext context,
    required Function cameraFct,
    required Function galleryFct,
    required Function removeFct,
  }) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TitleTextWidget(
                  label: "Choose Option",
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        cameraFct();
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.camera,
                        color: Colors.blue,
                        size: 28,
                      ),
                      label: const TitleTextWidget(
                        label: "Camera",
                        fontSize: 18,
                        color: Color(0xFF1C1030),
                      ),
                    ),
                    TextButton.icon(
                        onPressed: () {
                          galleryFct();
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Colors.lightBlue,
                          size: 28,
                        ),
                        label: const TitleTextWidget(
                          label: "Gallery",
                          fontSize: 18,
                          color: Color(0xFF1C1030),
                        )),
                    TextButton.icon(
                        onPressed: () {
                          removeFct();
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                          size: 28,
                        ),
                        label: const TitleTextWidget(
                            label: "Remove",
                            fontSize: 18,
                            color: Color(0xFF1C1030))),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
