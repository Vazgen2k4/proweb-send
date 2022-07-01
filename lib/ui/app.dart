import 'package:flutter/material.dart';
import 'package:proweb_send/ui/app_navigator/app_navigator.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppNavigator.initRoute,
      routes: AppNavigator.routes,
      onGenerateRoute: AppNavigator.generate,
    );
  }
}
