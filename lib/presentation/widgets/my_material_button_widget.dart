import 'package:flutter/material.dart';

class MyMaterialButton extends StatelessWidget {
  final onPressed;
  final String? text;
  const MyMaterialButton({this.text,this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(text!),
      color: Colors.blue,
      
    );
  }
}
