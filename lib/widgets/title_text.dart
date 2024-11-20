import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({
    super.key,
    required this.label,
    this.fontsize = 18,
    this.fontStyle = FontStyle.italic,
    this.fontWeight = FontWeight.bold,
    this.color,
    this.textDecoration = TextDecoration.none,
    this.maxLines,
  });
  final String label;
  final int? maxLines;
  final double fontsize;
  final FontStyle fontStyle;
  final FontWeight? fontWeight;
  final Color? color;
  final TextDecoration textDecoration;
  @override
  Widget build(BuildContext context) {
    return Text(label,
        maxLines: maxLines,
        style: TextStyle(
            fontSize: fontsize,
            fontWeight: fontWeight,
            color: color,
            fontStyle: fontStyle,
            decoration: textDecoration,
            overflow: TextOverflow.ellipsis));
  }
}
