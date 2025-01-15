import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const AuthGradientButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
              colors: [AppPallete.gradient1, AppPallete.gradient3],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
      child: ElevatedButton(
          onPressed:onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.transparentColor,
              shadowColor: AppPallete.transparentColor,
              fixedSize: const Size(390, 55)),
          child: Text(
            buttonText,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          )),
    );
  }
}
