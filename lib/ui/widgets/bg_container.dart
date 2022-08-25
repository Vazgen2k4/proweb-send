import 'package:flutter/material.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

class BgContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? action;
  const BgContainer({
    Key? key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.greyPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        child: child,
        onPressed: action,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(padding),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
    );
  }
}

