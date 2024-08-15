// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager(
      {super.key, required this.child, required this.isLoading});
  final Widget child;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          const Center(
              child: CircularProgressIndicator(
            color: Colors.blueAccent,
          )),
        ]
      ],
    );
  }
}
