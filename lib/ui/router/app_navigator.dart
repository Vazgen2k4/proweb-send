import 'package:flutter/material.dart';
import 'package:proweb_send/ui/pages/auth/auth_page.dart';
import 'package:proweb_send/ui/pages/auth/auth_page_confirm.dart';
import 'package:proweb_send/ui/pages/auth/auth_page_log_in.dart';
import 'package:proweb_send/ui/pages/auth/auth_page_start.dart';
import 'package:proweb_send/ui/pages/error_404_page/error_404_page.dart';
import 'package:proweb_send/ui/pages/home_page/home_page.dart';
import 'package:proweb_send/ui/pages/register/register_page.dart';
import 'package:proweb_send/ui/router/app_routes.dart';

class AppNavigator {
  static String initRoute = AppRoutes.auth;
  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.home: (context) => const HomePage(),
      AppRoutes.auth: (context) => const AuthPage(),
      AppRoutes.authStart: (context) => const AuthPageStart(),
      AppRoutes.authLogIn: (context) => const AuthPageLogIn(),
      AppRoutes.authConfirm: (context) => const AuthPageConfirm(),
      AppRoutes.register: (context) => const RegisterPage(),
    };
  }

  static Route generate(RouteSettings settings, {bool hasAuth = false}) {
    final _settings = RouteSettings(
      name: '/404',
      arguments: settings.arguments,
    );
    return MaterialPageRoute(
      settings: _settings,
      builder: (_) => const Error404Page(),
    );
  }
}
