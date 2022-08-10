import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

class CountryCodeBtn extends StatelessWidget {
  final Country country;
  final VoidCallback action;
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
