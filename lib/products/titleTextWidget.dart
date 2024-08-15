// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({
    super.key,
    required this.label,
    required this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.fontStyle = FontStyle.normal,
    this.color,
    this.maxLine,
  });
  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final Color? color;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLine,
      style: TextStyle(
        fontSize: fontSize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
