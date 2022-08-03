import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  double size;
  final String text;
  final Color color;
  final bool isBold;
  AppText(
      {Key? key,
      this.size = 16.0,
      this.isBold = false,
      required this.text,
      this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        ));
  }
}
