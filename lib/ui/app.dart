import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proweb_send/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:proweb_send/domain/bloc/settings_bloc/settings_bloc.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/router/app_navigator.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc()..add(const LoadAuth()),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => SettingsBloc()..add(const LoadSettings()),
        ),
      ],
      child: const AppContent(),
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({
    Key? key,
  }) : super(key: key);

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsBlocState>(
      builder: (context, state) {
        if (state is! SettingsBlocLoded) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return MaterialApp(
          showSemanticsDebugger: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.bg,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.greyPrimary,
            ),
          ),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: state.settings.locale,
          supportedLocales: S.delegate.supportedLocales,
          initialRoute: AppNavigator.initRoute,
          onGenerateRoute: (settings) => AppNavigator.generate(
            settings,
          ),
        );
      },
    );
  }
}
