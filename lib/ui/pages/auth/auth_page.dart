import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proweb_send/resources/resources.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
import 'package:rive/rive.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final duration = 5;

  Future<void> _toPage(bool hasAuth) async {
    final route = hasAuth ? AppRoutes.home : AppRoutes.authStart;
    print(route);
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    // final authState = context.watch<AuthCubit>().state;
    // Timer(Duration(seconds: duration), () => _toPage(authState.hasAuth));
    return const RiveAnimation.asset(AppAnimate.prev);
  }
}
