import 'package:shimmer/shimmer.dart';
import 'package:social_market/widgets/title_text.dart';
import 'package:flutter/material.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({super.key, this.fontSize = 50});

  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.indigo,
        highlightColor: Colors.red,
        child: TitleTextWidget(
          label: 'Tech Zone',
          fontsize: fontSize,
        ));
  }
}
