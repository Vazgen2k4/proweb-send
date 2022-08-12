import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:proweb_send/domain/bloc/auth_cubit/auth_cubit.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/auth/auth_button.dart';
import 'package:proweb_send/ui/widgets/auth/auth_cheker.dart';
import 'package:proweb_send/ui/widgets/auth/country_code_btn.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';

class AuthPageLogIn extends StatelessWidget {
  const AuthPageLogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();

    return AuthCheker(
      routTo: AppRoutes.home,
      child: Scaffold(
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
              const CountriCodeField(),
              const SizedBox(height: 48),
              AuthButton(
                title: S.of(context).create_button,
                action: () async {
                  final phone = authCubit.userPhone.phone;
                  if (phone.length < 7) return;
                  await authCubit.authRequestWithPhone(context, phone: phone);
                  Navigator.pushNamed(context, AppRoutes.authConfirm);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountriCodeField extends StatefulWidget {
  const CountriCodeField({Key? key}) : super(key: key);

  @override
  State<CountriCodeField> createState() => _CountriCodeFieldState();
}

class _CountriCodeFieldState extends State<CountriCodeField> {
  Country? _selectedCountry;

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
    });
  }

  void _onPressedShowSheet() async {
    final country = await showCountryPickerSheet(
      context,
      heightFactor: .5,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(S.of(context).choose_country_title),
      ),
      cornerRadius: 16,
      cancelWidget: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16,
          ),
          child: Text(S.of(context).exit_button),
        ),
      ),
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final country = _selectedCountry;
    authCubit.userPhone.countryCode = country?.callingCode;
    List<Widget> _children = [];

    if (country != null) {
      _children = [
        CountryCodeBtn(country: country, action: _onPressedShowSheet),
        Text(
          country.callingCode,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 24,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: authCubit.userPhone.phoneController,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              height: 1.33,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              MaskInputFormatter(mask: '## ### ## ##'),
            ],
            decoration: const InputDecoration(
              
              hintText: "-- --- -- --",
              labelText: "",
              counterText: "",
              border: InputBorder.none,
            ),
          ),
        ),
      ];
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.only(
          top: 8,
          right: 16,
          bottom: 8,
        ),
        constraints: const BoxConstraints.expand(
          height: 70,
          width: 293,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xff777777),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _children,
        ),
      ),
    );
  }
}
