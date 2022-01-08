import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final onChanged;
  final String? hint;
  final double? height;
  final double? width;
  final String? label;

  const MyTextField(
      {this.label,
      this.width,
      this.height,
      this.hint,
      this.controller,
      this.onChanged,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: TextFormField(
        initialValue: controller!.text,
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            hoverColor: Colors.blue,
            border: const OutlineInputBorder()),
      ),
    );
  }
}
