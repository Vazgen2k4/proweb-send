import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/bg_container.dart';
import 'package:proweb_send/ui/widgets/settings/user_settings_tile.dart';

class UserDataSettingsWidget extends StatelessWidget {
  final ProUser user;
  const UserDataSettingsWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = user.toDataInfo(context);
    final titles = userData.keys.toList();
    final subtitles = userData.values.toList();
    final defValue = user.defaultTitle(context);
    final _controls = <TextEditingController>[
      ProUser.controller.phoneController,
      ProUser.controller.userNikNameController,
      ProUser.controller.descrController,
    ];

    return BgContainer(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 34,
        bottom: 30,
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          if (index == 0) {
            return UserSettingsTile(
              dizabel: true,
              defTitle: defValue[index],
              key: UniqueKey(),
              keyboardType: TextInputType.phone,
              controller: _controls[index],
              icon: Transform.rotate(
                angle: pi / 2,
                child: const Icon(
                  Icons.remove_circle_outline_outlined,
                  color: AppColors.text,
                  size: 28,
                ),
              ),
              title: titles[index].trim(),
              subtitle: '${subtitles[index]}'.trim(),
            );
          }

          return UserSettingsTile(
            key: UniqueKey(),
            isArea: index == 2,
            defTitle: defValue[index],
            controller: _controls[index],
            hasOffset: true,
            title: titles[index].trim(),
            subtitle: '${subtitles[index]}'.trim(),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: userData.length,
      ),
    );
  }
}
