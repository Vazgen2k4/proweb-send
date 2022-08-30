import 'package:flutter/material.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

enum AuthButtonStyle { button, link }

class AuthButton extends StatelessWidget {
  final bool isTaped;
  final String title;
  final AuthButtonStyle style;
  final void Function()? action;

  const AuthButton({
    Key? key,
    required this.title,
    this.action,
    this.style = AuthButtonStyle.button,
    this.isTaped = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VoidCallback? _action = isTaped ? null : action;
    final isBtn = style == AuthButtonStyle.button;

    final _btnStyle = ButtonStyle(
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
    );

    final _linkStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
    );

    const _btnTextStyle = TextStyle(
      color: AppColors.text,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 2,
      height: 1.4,
    );
    const _linkTextStyle = TextStyle(
      decoration: TextDecoration.underline,
      color: AppColors.akcent,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 2,
      height: 1.25,
    );

    final _constrain = isBtn
        ? const BoxConstraints.expand(
            width: 293,
            height: 60,
          )
        : const BoxConstraints(maxWidth: 293, maxHeight: 20);

    return Center(
      child: ConstrainedBox(
        constraints: _constrain,
        child: TextButton(
          style: isBtn ? _btnStyle : _linkStyle,
          onPressed: _action,
          child: _child(
            btnStyle: isBtn ? _btnTextStyle : _linkTextStyle,
            isBtn: isBtn,
          ),
        ),
      ),
    );
  }

  Widget _child({
    required bool isBtn,
    required TextStyle btnStyle,
  }) {
    if (isBtn && isTaped) {
      return const CircularProgressIndicator(
        color: AppColors.text,
      );
    }

    return Text(
      title,
      textAlign: TextAlign.center,
      style: btnStyle,
    );
  }
}
