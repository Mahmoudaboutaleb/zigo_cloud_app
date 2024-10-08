// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zigo_cloud_app/common/colors.dart';
import 'package:zigo_cloud_app/screens/custom_map_widget.dart';

class CallInvitation extends StatefulWidget {
  const CallInvitation({
    super.key,
    required this.recipientID,
    required this.recipientName,
    required this.isVideoCall,
  });

  final String recipientID;
  final String recipientName;
  final bool isVideoCall;

  @override
  State<CallInvitation> createState() => _CallInvitationState();
}

class _CallInvitationState extends State<CallInvitation> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));

    final auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No user is currently logged in.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('zigoAppUsers').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Text(
                'Error fetching users',
                style: TextStyle(color: Colors.red),
              );
            }

            final users = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ZegoUIKitUser(id: data['uid'], name: data['name']);
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Know Your Frind's location",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorsWidgets.primaryColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MapScreen()));
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFFF9100),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(1, 3),
                                    )
                                  ]),
                              child: const Icon(
                                size: 30,
                                Icons.location_on,
                                color: ColorsWidgets.secondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Calling ${widget.recipientName.isNotEmpty ? widget.recipientName : "User"}...',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ZegoSendCallInvitationButton(
                    resourceID: "zegouikit_call",
                    invitees: [
                      ZegoUIKitUser(
                          id: widget.recipientID, name: widget.recipientName)
                    ],
                    isVideoCall: widget.isVideoCall,
                    icon: ButtonIcon(
                      icon: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.deepPurpleAccent,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              )
                            ]),
                        child: Icon(
                          widget.isVideoCall ? Icons.videocam : Icons.call,
                          color: ColorsWidgets.secondaryColor,
                          size: 30,
                        ),
                      ),
                    ),
                    text: widget.isVideoCall ? "Video Call" : "Voice Call",
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF351B5F),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cancel, size: 20),
                    label: const Text(
                      'Reject',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF02D1F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
