import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  GestureTapCallback onPressedButton;
  String? autoButton;

  CustomButton({
    required this.onPressedButton,
    required this.autoButton,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        MaterialButton(
          onPressed: onPressedButton,
          animationDuration: const Duration(seconds: 1),
          splashColor: Colors.white70,
          color: Colors.blue,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            autoButton!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
