import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';

import 'package:country_calling_code_picker/picker.dart';

class AuthWithNumber extends StatelessWidget {
  const AuthWithNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.auth(
        child: Center(
          child: Text(
            S.of(context).create_title,
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
          ],
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
      title: Text(S.of(context).choose_country_title),
      cornerRadius: 16,
      cancelWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(S.of(context).exit_button),
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
    final country = _selectedCountry;

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
            scrollPadding: EdgeInsets.zero,
            style:const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              height: 1,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              MaskInputFormatter(mask: '## ### ## ##' ),
            ],
            // maxLines: 1,
            decoration:const InputDecoration(
              hintText: "-- --- -- --",
              labelText: "",
              counterText: "",
              border: InputBorder.none,
              
            ),
          ),
        ),
      ];
    }

    return Container(
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
    );
  }
}

class CountryCodeBtn extends StatelessWidget {
  final Country country;
  final void Function() action;
  const CountryCodeBtn({
    Key? key,
    required this.country,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              country.flag,
              package: countryCodePackageName,
              width: 30,
              height: 20,
              fit: BoxFit.fill,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.text,
          ),
        ],
      ),
    );
  }
}
