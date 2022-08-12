import 'package:flutter/material.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:proweb_send/domain/bloc/auth_cubit/auth_cubit.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/auth/auth_button.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';

class AuthPageConfirm extends StatelessWidget {
  const AuthPageConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

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
                  controller: authCubit.userPhone.smsController,
                ),
              ),
              const SizedBox(height: 48),
              AuthButton(
                title: S.of(context).create_button,
                action: () async {
                  final needRegist = await authCubit.authConfirmWithPhone();
                  if (needRegist == null) return;
                  final route =
                      needRegist ? AppRoutes.register : AppRoutes.home;
                  Navigator.pushNamed(context, route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
