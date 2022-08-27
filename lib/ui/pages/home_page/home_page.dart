import 'package:flutter/material.dart';
import 'package:proweb_send/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:proweb_send/ui/pages/chats/chats_page.dart';
import 'package:proweb_send/ui/pages/contacts/contacts_page.dart';
import 'package:proweb_send/ui/pages/settings/settings_page.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexPage = 0;
  final pageController = PageController();
  final _items = const [
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
  late final List<Widget> _content;

  @override
  void initState() {
    _content = [
      const ChatsPage(),
      const ContactsPage(),
      SettingsPage(pageController: pageController),
    ];

    // pageController.addListener(() {
    //   indexPage = pageController.page!.toInt();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        authBloc.add(const AuthLogOut());
      }),
      body: PageView.builder(
        onPageChanged: _pageChange,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _content[index],
        itemCount: _content.length,
      ),
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
          destinations: _items,
          selectedIndex: indexPage,
          onDestinationSelected: _pageChange,
        ),
      ),
    );
  }

  void _pageChange(int index) async {
    pageController.jumpToPage(
      index,
    );
    setState(() {
      indexPage = index;
    });
  }
}
