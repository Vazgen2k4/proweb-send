import 'package:flutter/material.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/pages/auth/auth_create_widget.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/auth/auth_button.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';

class AuthLogIn extends StatelessWidget {
  const AuthLogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.auth(
        child: Center(
          child: Text(
            S.of(context).auth_title,
            style: const TextStyle(
              fontSize: 20,
              height: 24 / 20,
              letterSpacing: 1,
              color: AppColors.text,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: Text(
                S.of(context).number_telephone,
                style: const TextStyle(
                  fontSize: 20,
                  height: 24 / 20,
                  letterSpacing: 1,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: 70),
            const Center(child: CountriCodeField()),
            const SizedBox(height: 48),
            AuthButton(title: S.of(context).auth_button),
            const SizedBox(height: 90),
            AuthButton(
              title: S.of(context).other_auth_link,
              style: AuthButtonStyle.link,
              action: () {
                Navigator.pushNamed(context, AppRoutes.authLogInOther);
              },
            ),
          ],
        ),
      ),
    );
  }
}
