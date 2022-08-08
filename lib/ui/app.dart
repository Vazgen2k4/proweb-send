import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proweb_send/domain/bloc/auth_cubit/auth_cubit.dart';
import 'package:proweb_send/domain/bloc/settings_bloc/settings_bloc.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/router/app_navigator.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
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
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
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
    final authState = context.watch<AuthCubit>().state;

    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColors.bg),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: AppNavigator.initRoute,
      onGenerateRoute: (settings) => AppNavigator.generate(
        settings,
        hasAuth: authState.hasAuth,
      ),
      // routes: AppNavigator.routes,
    );
  }
}
