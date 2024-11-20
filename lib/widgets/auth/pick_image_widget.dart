import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({super.key, this.pickedImage, required this.function});
  final XFile? pickedImage;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: pickedImage == null
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                      ),
                    )
                  : Image.file(
                      File(pickedImage!.path),
                      fit: BoxFit.fill,
                    )),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            borderRadius: BorderRadius.circular(12),
            color: Colors.lightBlue,
            child: InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.red,
                onTap: () {
                  function();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(IconlyLight.camera),
                )),
          ),
        )
      ],
    );
  }
}
