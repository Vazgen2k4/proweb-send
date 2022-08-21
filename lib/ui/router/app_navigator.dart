import 'package:flutter/material.dart';
import 'package:proweb_send/ui/pages/auth/auth_page.dart';
import 'package:proweb_send/ui/pages/auth/auth_page_confirm.dart';
import 'package:proweb_send/ui/pages/auth/auth_page_log_in.dart';
import 'package:proweb_send/ui/pages/auth/auth_page_start.dart';
import 'package:proweb_send/ui/pages/error_404_page/error_404_page.dart';
import 'package:proweb_send/ui/pages/home_page/home_page.dart';
import 'package:proweb_send/ui/pages/register/register_page.dart';
import 'package:proweb_send/ui/pages/settings/settings_theme_page.dart';
import 'package:proweb_send/ui/router/app_routes.dart';

class AppNavigator {
  static String initRoute = AppRoutes.auth;

  static Route generate(RouteSettings settings) {
    final name = settings.name ?? '/404';
    const duration = 500; 

    final _settings = RouteSettings(
      name: name,
      arguments: settings.arguments,
    );

    switch (name) {
      case AppRoutes.authLogIn:
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: duration),
          pageBuilder: (_, __, ___) => const AuthPageLogIn(),
        );
      case AppRoutes.settingsTheme:
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: duration),
          pageBuilder: (_, __, ___) => const SettingsThemePage(),
        );
      case  AppRoutes.home:
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: duration),
          pageBuilder: (_, __, ___) => const HomePage(),
        );
      case AppRoutes.auth:
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: duration),
          pageBuilder: (_, __, ___) => const AuthPage(),
        );
      case AppRoutes.authStart:
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: duration),
          pageBuilder: (_, __, ___) => const AuthPageStart(),
        );
      case AppRoutes.authConfirm:
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: duration),
          pageBuilder: (_, __, ___) => const AuthPageConfirm(),
        );
      case AppRoutes.register:
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: duration),
          pageBuilder: (_, __, ___) => const RegisterPage(),
        );
      default:
        return MaterialPageRoute(
          settings: _settings,
          builder: (_) => const Error404Page(),
        );
    }
  }
}
