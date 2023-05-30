import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
  }) : super(key: key);

  final void Function() onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
