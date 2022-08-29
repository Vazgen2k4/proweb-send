import 'package:flutter/material.dart';
import 'package:proweb_send/ui/router/app_routes.dart';

class Error404Page extends StatelessWidget {
  const Error404Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Страница не найдена')),
      body:  Center(
        child: TextButton(
          child: const Text(
            'Ошибка 404',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 40, 38, 38),
              fontSize: 26,
            ),
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_)=> false);
          },
        ),
      ),
    );
  }
}
