import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proweb_send/domain/bloc/settings/settings_bloc.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/router/app_navigator.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final model = SettingsBloc();
            model.add(
              const LoadSettings(
                SettingsBlocLoded(
                  theme: SettingsThemeOptions(),
                  language: Locale('ru'),
                ),
              ),
            );
            return model;
          },
        ),
      ],
      child: const _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsBlocState>(
      builder: (context, state) {
        final Locale? _locale =
            state is SettingsBlocLoded ? state.language : null;

        final theme = state is SettingsBlocLoded && state.theme.isDark
            ? ThemeData.dark()
            : ThemeData.light();

        return MaterialApp(
          theme: ThemeData(scaffoldBackgroundColor: AppColors.bg),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: _locale,
          initialRoute: AppNavigator.initRoute,
          onGenerateRoute: AppNavigator.generate,
        );
      },
    );
  }
}
