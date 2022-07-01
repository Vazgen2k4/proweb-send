import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proweb_send/domain/providers/auth_provider.dart';
import 'package:proweb_send/ui/app_navigator/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: TextField(
          controller: authModel.phoneModel.phoneController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigator.pushNamed(context, AppRoutes.second);
          await authModel.phoneModel.auth();
        },
      ),
    );
  }
}
