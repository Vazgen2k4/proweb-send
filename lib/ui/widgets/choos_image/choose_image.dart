import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

class ChoseImageWidget extends StatefulWidget {
  final double radius;
  final NetworkImage? image;
  const ChoseImageWidget({
    Key? key,
    this.radius = 50,
    this.image,
  }) : super(key: key);

  @override
  State<ChoseImageWidget> createState() => _ChoseImageWidgetState();
}

class _ChoseImageWidgetState extends State<ChoseImageWidget> {
  String? imgPath;
  ImageProvider<Object>? img;

  @override
  void initState() {
    img = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userController = ProUser.controller;

    return GestureDetector(
      onTap: () async {
        try {
          final file = await userController.selectImage();
          if (file == null) return;
          imgPath = file.path;

          img = imgPath != null ? FileImage(File(imgPath!)) : null;
          setState(() {});
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: CircleAvatar(
          backgroundColor: const Color(0xffd9d9d9),
          backgroundImage: img,
          radius: widget.radius,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: widget.radius,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(3, 3, 3, .5),
              ),
              child: const Icon(
                Icons.photo_camera_rounded,
                color: AppColors.text,
                size: 31,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
