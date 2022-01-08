import 'dart:io';

import 'package:chair_inspector/business%20logic/cubit/sqflite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'dart:convert';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key, this.height, this.width})
      : super(key: key);
  final double? height;
  final double? width;

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  final pickedFile = ImagePicker();
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SqfliteCubit()..createDataBase(),
      child: Container(
        height: widget.height,
        width: widget.width,
        color: Colors.grey[600],
        child: imagePickerFieldWidget(),
      ),
    );
  }

  Future pickUpImageFromCamera() async {
    final picker = ImagePicker();
    imagePath='';
    await picker
        .getImage(source: ImageSource.camera, imageQuality: 90)
        .then((value) {
      imagePath = value!.path;
      if (imagePath != null) {
        setState(() {
          _imageFile = File(imagePath!);
        });
      }
    });
  }

  Widget showImageOrIconWidget() {
    return _imageFile != null
        ? Image.file(_imageFile!)
        : const Icon(
            Icons.camera_alt_outlined,
            size: 70.0,
          );
  }

  Widget imagePickerFieldWidget(){
    return InkWell(
          onTap: () {
            onImageFieldTapped();
          },
          splashColor: Colors.black,
          child: showImageOrIconWidget(),
          focusColor: Colors.grey,
          highlightColor: Colors.grey,
        );
  }

  void onImageFieldTapped() {
    pickUpImageFromCamera().then((_) {
      SqfliteCubit.get(context).imagePath = imagePath;
    });
  }
}
