import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proweb_send/domain/bloc/settings/settings_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SettingsBloc>();
    final state = model.state as SettingsBlocLoded;
    
    return Scaffold(
      appBar: AppBar(
        title: Material(
          color: Colors.transparent,
          child: InkWell(
            onLongPress: () async {
              model.add(SetTheme(!state.theme.isDark));
            },
            child: Text(
              '${state.language.languageCode} -- ${state.theme.isDark ? "To light" : "To dark"}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: const Center(
        child: TextField(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
            if(state.language.languageCode == 'ru') {
              model.add(const SwitchLanguage(Locale('en')));
            } else {
              model.add(const SwitchLanguage(Locale('ru')));
            }
        },
      ),
    );
  }
}
