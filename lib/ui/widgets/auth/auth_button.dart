import 'package:flutter/material.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

enum AuthButtonStyle { button, link }

class AuthButton extends StatelessWidget {
  final String title;
  final AuthButtonStyle style;
  final void Function()? action;

  const AuthButton({
    Key? key,
    required this.title,
    this.action,
    this.style = AuthButtonStyle.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(
        width: 293,
        height: 60,
      ),
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 45,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            AppColors.akcentSecondary,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        onPressed: action,
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
