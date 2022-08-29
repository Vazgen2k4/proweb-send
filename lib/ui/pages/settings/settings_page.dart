import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proweb_send/domain/bloc/settings_bloc/settings_bloc.dart';
import 'package:proweb_send/ui/pages/settings/settings_page_app_bar.dart';
import 'package:proweb_send/ui/pages/settings/settings_page_content.dart';

class SettingsPage extends StatelessWidget {
  final PageController pageController;
  const SettingsPage({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SettingsBloc, SettingsBlocState>(
      builder: (context, state) {
        if (state is! SettingsBlocLoded) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = state.user;

        final imagePath = user.imagePath;
        final img = imagePath != null ? NetworkImage(imagePath) : null;

        return CustomScrollView(
          slivers: <Widget>[
            SettingsPageAppBar(user: user, img: img),
            SettingsPageContent(user: user),
          ],
        );
      },
    );
  }
}
