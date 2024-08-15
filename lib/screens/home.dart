import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zigo_cloud_app/common/static.dart';
import 'package:zigo_cloud_app/common/widgets/top_bar.dart';
import 'package:zigo_cloud_app/models/user_models.dart';
import 'package:zigo_cloud_app/screens/login.dart';
import 'package:zigo_cloud_app/services/firebase_services.dart';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseService.currentUser;

    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: currentUser == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No user is currently logged in.'),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200, // Adjust the width as needed
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xff6D28D9), // Button color
                          padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 25), // Padding inside the button
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  'Welcome, ${currentUser.name}'), // If a user is logged in, display their name or another welcome message.
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                TopBar(
                  title: currentUser.name,
                  upperTitle: "Welcome Back",
                  showLogoutButton: true,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseService.buildViews,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                  final List<UserModel> users = docs
                      .map((doc) => UserModel.fromJson(
                          doc.data() as Map<String, dynamic>))
                      .where((user) => user.name != currentUser.name)
                      .toList();

                  if (users.isEmpty) {
                    return const Center(
                      child: Text("No other users found."),
                    );
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 14.0),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 26,
                              child: Text(
                                user.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              icon: const Icon(Icons.call, color: Colors.green),
                              onPressed: () {
                                _initiateCall(
                                  context,
                                  currentUser.email,
                                  currentUser.name,
                                  user.email,
                                  isVideoCall: false,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.videocam,
                                  color: Colors.blue),
                              onPressed: () {
                                _initiateCall(
                                  context,
                                  currentUser.email,
                                  currentUser.name,
                                  user.email,
                                  isVideoCall: true,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initiateCall(
      BuildContext context, String userID, String userName, String recipientID,
      {required bool isVideoCall}) {
    final callID = 'call_$recipientID${DateTime.now().millisecondsSinceEpoch}';
    final config = isVideoCall
        ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZegoUIKitPrebuiltCall(
          appID: Statics.appID,
          appSign: Statics.appSign,
          userID: userID,
          userName: userName,
          callID: callID,
          config: config,
        ),
      ),
    );
  }
}
