import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/ui/pages/settings/settings_page_app_bar.dart';
import 'package:proweb_send/ui/pages/settings/settings_page_content.dart';

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
            SettingsPageAppBar(user: user, img: img),
            SettingsPageContent(user: user),
          ],
        );
      },
    );
  }
}
