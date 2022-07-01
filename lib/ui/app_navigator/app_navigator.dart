import 'package:flutter/material.dart';
import 'package:proweb_send/ui/app_navigator/app_routes.dart';
import 'package:proweb_send/ui/pages/error_404_page/error_404_page.dart';
import 'package:proweb_send/ui/pages/home_page/home_page.dart';

class AppNavigator {
  static String initRoute = AppRoutes.home;

  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.home: (_) => const HomePage(),
    };
  }

  static Route generate(RouteSettings settings) {
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
