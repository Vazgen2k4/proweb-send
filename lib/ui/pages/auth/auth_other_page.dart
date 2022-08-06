import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proweb_send/domain/bloc/auth_cubit/auth_cubit.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/resources/resources.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/auth/auth_button.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';


class AuthOtherPage extends StatelessWidget {
  const AuthOtherPage({Key? key}) : super(key: key);

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
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: <Widget>[
            const OtherAuthBtnBar(),
            const SizedBox(height: 70),
            AuthButton(
              title: S.of(context).have_account_link,
              style: AuthButtonStyle.link,
              action: () {
                Navigator.pushNamed(context, AppRoutes.authLogIn);
              },
            )
          ],
        ),
      ),
    );
  }
}

class OtherAuthBtnBar extends StatelessWidget {
  const OtherAuthBtnBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubite = context.read<AuthCubit>();

    return Center(
      child: SizedBox(
        width: 285,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AuthOtherBtn(
              src: AppIcons.google,
              title: 'Google',
              action: () async {
                authCubite.authWithGoogle();
              },
            ),
            AuthOtherBtn(
              src: AppIcons.appleId,
              title: 'Apple id',
              action: () {},
            ),
            AuthOtherBtn(
              src: AppIcons.facebook,
              title: 'Facebook',
              action: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class AuthOtherBtn extends StatelessWidget {
  final String title;
  final String src;
  final void Function()? action;

  const AuthOtherBtn({
    Key? key,
    required this.title,
    required this.src,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: action,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              src,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              title.trim(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
                height: 1.18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
