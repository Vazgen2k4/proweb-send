import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget child;

  const CustomAppBar({
    Key? key,
    this.height = kToolbarHeight,
    required this.child,
  }) : super(key: key);

  const CustomAppBar.auth({
    Key? key,
    required this.child,
  }) : height = 160, super(key: key);


  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
