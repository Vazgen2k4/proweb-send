import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proweb_send/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:proweb_send/resources/resources.dart';
import 'package:proweb_send/ui/pages/auth/auth_page_start.dart';
import 'package:proweb_send/ui/pages/home_page/home_page.dart';
import 'package:proweb_send/ui/pages/register/register_page.dart';
import 'package:rive/rive.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthLoaded) {
          return const RiveAnimation.asset(AppAnimate.prev);
        }
        if (state.hasAuth && !state.needRegister) {
          return const HomePage();
        }

        if (state.needRegister) {
          return const RegisterPage();
        }
        return const AuthPageStart();
      },
    );
  }
}
