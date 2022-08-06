import 'package:flutter/material.dart';
import 'package:proweb_send/ui/pages/auth/auth_login.dart';
import 'package:proweb_send/ui/pages/auth/auth_other_page.dart';
import 'package:proweb_send/ui/pages/auth/auth_page.dart';
import 'package:proweb_send/ui/pages/auth/auth_page_content.dart';
import 'package:proweb_send/ui/pages/auth/auth_create_widget.dart';
import 'package:proweb_send/ui/pages/error_404_page/error_404_page.dart';
import 'package:proweb_send/ui/pages/home_page/home_page.dart';
import 'package:proweb_send/ui/router/app_routes.dart';

class AppNavigator {
  static String initRoute = AppRoutes.auth;

  static Map<String, dynamic>? _getSplittor(String sours) {

  }

  static Route generate(RouteSettings settings) {
    const duration = Duration(milliseconds: 1000);
    String name = settings.name ?? '/404';
       
    switch (name) {
      case (AppRoutes.home):
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondanimation) {
            return const HomePage();
          },
          transitionDuration: duration,
        );

      case (AppRoutes.auth):
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondanimation) {
            return const AuthPage();
          },
          transitionDuration: duration,
        );
      case (AppRoutes.authStart):
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondanimation) {
            return const AuthPageContent();
          },
          transitionDuration: duration,
        );
      case (AppRoutes.authCreate):
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondanimation) {
            return const AuthCreateWidget();
          },
          transitionDuration: duration,
        );
      case (AppRoutes.authLogIn):
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondanimation) {
            return const AuthLogIn();
          },
          transitionDuration: duration,
        );
      case (AppRoutes.authLogInOther):
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondanimation) {
            return const AuthOtherPage();
          },
          transitionDuration: duration,
        );

      default:
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
}
