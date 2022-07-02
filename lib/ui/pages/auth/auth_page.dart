import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proweb_send/resources/resources.dart';
import 'package:proweb_send/ui/router/app_routes.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final duration = 5;

  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: duration),
      () => Navigator.of(context).pushReplacementNamed(AppRoutes.authStart)
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppGifs.splash),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
