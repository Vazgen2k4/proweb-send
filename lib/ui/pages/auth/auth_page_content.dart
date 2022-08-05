import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/resources/resources.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/auth/auth_button.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';

class AuthPageContent extends StatelessWidget {
  const AuthPageContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.auth(
        child: Center(
          child: Text(
            S.of(context).hello_title,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset(AppIcons.logo),
              const SizedBox(height: 38.25),
              SvgPicture.asset(AppIcons.appTitle),
              const SizedBox(height: 60.62),
              AuthButton(
                title: S.of(context).start_btn_txt,
                action: () {
                  Navigator.of(context).pushNamed(AppRoutes.authCreate);
                },
              ),
              const SizedBox(height: 60.62),
            ],
          ),
        ),
      ),
    );
  }
}
