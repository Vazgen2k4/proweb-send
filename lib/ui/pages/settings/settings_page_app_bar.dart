import 'dart:ffi';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/domain/bloc/settings_bloc/settings_bloc.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/choos_image/choose_image.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPageAppBar extends StatelessWidget {
  final ProUser user;
  final NetworkImage? img;
  const SettingsPageAppBar({Key? key, required this.user, this.img})
      : super(key: key);

  void _safe(BuildContext context) async {
    final state = context.read<SettingsBloc>().state;

    if (state is! SettingsBlocLoded) return;
    await state.settings.saveSettingsOnDevice();

    final userNik = ProUser.controller.userNikNameController.value.text;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (userNik.isEmpty || uid == null) return;

    final isBusy = await FirebaseCollections.busyNikName(nikNameId: userNik);
    final isNewNik = user.nikNameId != userNik;

    if (isBusy && isNewNik) return;
    final descr = ProUser.controller.descrController.value.text;
    final nikId = ProUser.controller.userNikNameController.value.text;
    final newUser = user.copyWith(descr: descr, nikNameId: nikId);

    await FirebaseCollections.addUserTo(
        userId: uid, userData: newUser.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
     
      actions: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => _safe(context),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Text(
              S.of(context).done,
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
                color: AppColors.text,
              ),
            ),
          ),
        ),
      ],
      automaticallyImplyLeading: false,
      centerTitle: true,
      floating: true,
      pinned: true,
      expandedHeight: 170,
      snap: true,
      flexibleSpace: bg(
        opacity: 1,
        child: FlexibleSpaceBar(
          stretchModes: const [
            StretchMode.fadeTitle,
            StretchMode.blurBackground
          ],
          centerTitle: true,
          expandedTitleScale: 1,
          collapseMode: CollapseMode.pin,
          title: Center(
            child: ChoseImageWidget(
              radius: 40,
              image: img,
            ),
          ),
        ),
      ),
      forceElevated: true,
      backgroundColor: Colors.transparent,
      bottom: CustomAppBar(
        height: kToolbarHeight,
        child: SettingsAppBarContent(user: user),
      ),
    );
  }

  Widget bg({Widget? child, double opacity = .8}) {
    return ClipRRect(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(109, 246, 255, opacity),
              Color.fromRGBO(113, 255, 221, opacity),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: child,
        ),
      ),
    );
  }
}

class SettingsAppBarContent extends StatelessWidget {
  const SettingsAppBarContent({
    Key? key,
    required this.user,
  }) : super(key: key);

  final ProUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Text(
            user.name ?? '',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 17,
              letterSpacing: -.41,
              height: 22 / 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            (user.nikNameId ?? ''),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 13,
              letterSpacing: -.41,
              height: 22 / 13,
            ),
          ),
        ],
      ),
    );
  }
}
