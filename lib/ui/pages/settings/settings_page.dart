import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/choos_image/choose_image.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';

class SettingsPage extends StatelessWidget {
  final PageController pageController;
  const SettingsPage({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'user-id';

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(FirebaseCollections.usersPath)
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data;

          if (!snapshot.hasData || data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = ProUser.fromJson(data.data());
          final imagePath = user.imagePath;
          final img = imagePath != null ? NetworkImage(imagePath) : null;

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back),
                ),
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
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 36,
                  horizontal: 16,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      UserDataSettingsWidget(
                        user: user,
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
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
            '@' + (user.nikNameId ?? ''),
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

class UserSettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool hasOffset;
  final Widget? icon;

  const UserSettingsTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.hasOffset = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: icon!,
            ),
          if (icon == null) const SizedBox(width: 44),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textInfo,
                    fontSize: 14,
                    height: 24 / 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    height: 24 / 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BgContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsets padding;
  const BgContainer({
    Key? key,
    this.child,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.greyPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
