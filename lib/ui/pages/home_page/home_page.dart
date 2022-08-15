import 'package:flutter/material.dart';
import 'package:proweb_send/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    const _tems = [
      NavigationDestination(
        icon: Icon(Icons.chat_outlined),
        label: '',
      ),
      NavigationDestination(
        icon: Icon(Icons.perm_contact_cal_outlined),
        label: '',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        label: '',
      ),
    ];

    final _content = <Widget>[
      Container(
        color: Colors.red,
      ),
      Container(
        color: Colors.green,
      ),
      Container(
        color: Colors.purple,
      ),
    ];

    final authBloc = context.read<AuthBloc>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        authBloc.add(const AuthLogOut());
      }),
      body: _content[indexPage],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 80,
          iconTheme: MaterialStateProperty.all(
            const IconThemeData(
              color: Color.fromARGB(255, 255, 255, 255),
              size: 25,
            ),
          ),
          indicatorColor: const Color(0xff7489FF),
        ),
        child: NavigationBar(
          backgroundColor: AppColors.elementsPrimary,
          destinations: _tems,
          selectedIndex: indexPage,
          onDestinationSelected: (v) => setState(() => indexPage = v),
        ),
      ),
    );
  }
}
