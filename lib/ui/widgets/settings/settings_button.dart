import 'package:flutter/material.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/bg_container.dart';

class SettingsButton extends StatelessWidget {
  final IconData? icon;
  final String title;
  final VoidCallback? action;
  final bool setCenter;
  final Widget? traling;

  const SettingsButton({
    Key? key,
    this.icon,
    required this.title,
    this.action,
    this.setCenter = false,
    this.traling,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BgContainer(
      padding: const EdgeInsets.all(16),
      action: action,
      child: Row(
        mainAxisAlignment:
            setCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (icon != null)
            Center(
              child: Icon(
                icon,
                color: AppColors.akcent,
                size: 28,
              ),
            ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w500,
              color: AppColors.akcent,
            ),
          ),
          if (traling != null) const Spacer(),
          if (traling != null) traling!,
        ],
      ),
    );
  }
}
