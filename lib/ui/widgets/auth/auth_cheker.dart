import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proweb_send/domain/bloc/auth_cubit/auth_cubit.dart';

class AuthCheker extends StatelessWidget {
  final Widget? child;
  final String routTo;
  const AuthCheker({
    Key? key,
    this.child,
    required this.routTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        Navigator.pushReplacementNamed(
          context,
          routTo,
        );
      },
      child: child,
    );
  }
}
