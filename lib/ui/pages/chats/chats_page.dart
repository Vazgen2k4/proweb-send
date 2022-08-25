import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/bg_container.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(FirebaseCollections.usersPath)
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final userData = snapshot.data;
        if (!snapshot.hasData || userData == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final user = ProUser.fromJson(userData.data());
        print(user.chats?.first);

        return Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Text(
                    'data',
                    style: TextStyle(
                      color: AppColors.text,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// class ChatTile extends StatelessWidget {
//   final String chatId;

//   const ChatTile({
//     Key? key,
//     required this.chatId,
//   }) : super(key: key);

//   Future<ProUser> _getUser() async{
//     final id = FirebaseFirestore.instance.collection('chats').doc(chatId).get();

//     return ;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ProUser>(
//       future: ,
//       builder: (context, snapshot) {
//         return;
//       },
//     );
//     // return BgContainer();
//   }
// }
