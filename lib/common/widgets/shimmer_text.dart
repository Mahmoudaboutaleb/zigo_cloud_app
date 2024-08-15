// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zigo_cloud_app/products/titleTextWidget.dart';

class ShimmerAppText extends StatelessWidget {
  const ShimmerAppText(
      {super.key,
      required this.label,
      required this.fontWeight,
      required this.startColor,
      required this.endColor,
      required this.fontSize});
  final String label;
  final FontWeight fontWeight;
  final Color startColor;
  final Color endColor;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(seconds: 7),
        baseColor: startColor,
        highlightColor: endColor,
        child: TitleTextWidget(
          label: label,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ));
  }
}
