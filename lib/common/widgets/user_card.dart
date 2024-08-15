import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zigo_cloud_app/models/user_models.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key, required this.userModels});
  final UserModel userModels;
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 75,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.05),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(10, 20),
              )
            ]),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 25,
              child: Center(
                child: Text(
                  widget.userModels.name.substring(0, 1).toUpperCase(),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              widget.userModels.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Spacer(),
            actionButton(false),
            actionButton(true),
          ],
        ),
      ),
    );
  }

  ZegoSendCallInvitationButton actionButton(bool isVideo) {
    return ZegoSendCallInvitationButton(
      isVideoCall: isVideo,
      resourceID: "zegouikit_call",
      invitees: [
        ZegoUIKitUser(id: widget.userModels.email, name: widget.userModels.name)
      ],
      icon: ButtonIcon(
        icon: Icon(
          isVideo ? Icons.videocam : Icons.phone,
          color: Colors.white, // تخصيص لون الأيقونة
        ),
        backgroundColor: Colors.blue, // تخصيص لون الخلفية
      ),
    );
  }
}

// ZegoSendCallInvitationButton actionButton(bool isVideo) {
//     return ZegoSendCallInvitationButton(
//       isVideoCall: isVideo,
//       resourceID: "zegouikit_call",
//       invitees: [
//         ZegoUIKitUser(id: widget.userModels.email, name: widget.userModels.name)
//       ],
//     );
// }
