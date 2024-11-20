import 'package:flutter/material.dart';
import 'package:social_market/screens/search_screen.dart';
import 'package:social_market/widgets/subtitle_text.dart';
import 'package:social_market/widgets/title_text.dart';

import '../root_screen.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget(
      {super.key,
      required this.imagepath,
      required this.title,
      required this.subtitle,
      required this.buttonText});
  final String imagepath, title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Image.asset(
              imagepath,
              height: size.height * 0.35,
              width: double.infinity,
            ),
            const TitleTextWidget(
              label: 'Whoops',
              fontsize: 40,
              color: Colors.red,
            ),
            SubtitleTextWidget(
              label: title,
              fontWeight: FontWeight.w600,
              fontsize: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SubtitleTextWidget(
                label: subtitle,
                fontWeight: FontWeight.w400,
                fontsize: 18,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, RootScreen.routName);
                },
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
