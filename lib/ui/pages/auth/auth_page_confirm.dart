import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';
import 'package:proweb_send/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/app_hero_tags.dart';
import 'package:proweb_send/ui/widgets/auth/auth_button.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';

class AuthPageConfirm extends StatelessWidget {
  const AuthPageConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void confirm() async {
      final authBloc = context.read<AuthBloc>();
      final state = authBloc.state;

      if (state is! AuthLoaded) return;

      authBloc.add(
        AuthVerifirePhone(
          onSuccess: () async {
            final needCreate = await FirebaseCollections.needRegistr(
              userId: FirebaseAuth.instance.currentUser?.uid,
            );

            if (needCreate == null) return;

            Navigator.pushNamedAndRemoveUntil(
              context,
              needCreate ? AppRoutes.register : AppRoutes.auth,
              (_) => false,
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar.auth(
        child: Center(
          child: Text(
            S.of(context).create_title,
            textAlign: TextAlign.center,
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
        child: SingleChildScrollView(
          child: Column(
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
              SizedBox(
                width: 125,
                child: TextField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    height: 42 / 28,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MaskInputFormatter(mask: '### ###'),
                  ],
                  maxLength: 7,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      height: 42 / 28,
                    ),
                    hintText: "--- ---",
                    counterText: "",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff777777),
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff777777),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff777777),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  controller: ProUser.controller.smsController,
                ),
              ),
              const SizedBox(height: 48),
              Hero(
                tag: AppHeroTags.authBtn,
                child: AuthButton(
                  title: S.of(context).create_button,
                  action: confirm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
