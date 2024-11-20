import 'package:flutter/material.dart';
import 'package:social_market/widgets/title_text.dart';

import '../widgets/subtitle_text.dart';
import 'assets_manager.dart';

class MyAppMethods {
  static Future<void> showErrorOrWarningDialog(
      {required BuildContext context,
      required String subtitle,
      required Function fct,
      bool isError = true}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AssetsMamager.warning,
                  height: 60,
                  width: 60,
                ),
                SizedBox(
                  height: 16,
                ),
                SubtitleTextWidget(label: subtitle),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: isError,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: SubtitleTextWidget(
                            label: "Cancel",
                            color: Colors.blue,
                          )),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);

                          fct();
                        },
                        child: SubtitleTextWidget(
                          label: "ok",
                          color: Colors.red,
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCt,
  }) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: TitleTextWidget(
                label: "Choose option",
              ),
            ),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                TextButton.icon(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      cameraFCT();
                    },
                    icon: Icon(Icons.camera),
                    label: Text("camera")),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      galleryFCT();
                    },
                    icon: Icon(Icons.image),
                    label: Text("gallery")),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      removeFCt();
                    },
                    icon: Icon(Icons.remove),
                    label: Text("delete")),
              ],
            )),
          );
        });
  }
}
