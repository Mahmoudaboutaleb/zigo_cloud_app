import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zigo_cloud_app/common/static.dart';

class CallInvitationPage extends StatelessWidget {
  const CallInvitationPage({
    super.key,
    required this.child,
    required this.userName,
  });

  final Widget child;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCallWithInvitation(
      appID: Statics.appID,
      appSign: Statics.appSign,
      userID: userName,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      callID: 'unique_call_id_${DateTime.now().millisecondsSinceEpoch}',
      child: child,
    );
  }
}

class ZegoUIKitPrebuiltCallWithInvitation extends StatelessWidget {
  final int appID;
  final String appSign;
  final String userID;
  final String userName;
  final String callID;
  final Widget child;
  final List<IZegoUIKitPlugin>? plugins;

  const ZegoUIKitPrebuiltCallWithInvitation({
    super.key,
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.callID,
    required this.child,
    required this.plugins,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: appID,
      appSign: appSign,
      userID: userID,
      userName: userName,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig(),
      plugins: plugins,
    );
  }
}
