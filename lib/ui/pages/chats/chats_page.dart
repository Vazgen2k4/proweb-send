import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/chat_model.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/ui/pages/chats/singl_chat_page.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/bg_container.dart';

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
        final chats = user.chats ?? [];

        return Column(
          children: [
            AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: const Text(
                'Чаты',
                style: TextStyle(
                  fontSize: 22,
                  height: 28 / 22,
                  color: AppColors.text,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    size: 24,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
            Expanded(
              child: chats.isNotEmpty
                  ? ListView.separated(
                      separatorBuilder: (_, __) => const SizedBox(height: 15),
                      padding: const EdgeInsets.all(16),
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        return ChatTile(chatId: chats[index]);
                      },
                    )
                  : const Text(
                      'У вас нет чатов',
                      style: TextStyle(color: AppColors.text),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class ChatTile extends StatelessWidget {
  final String chatId;

  const ChatTile({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  Future<ChatTileData?> _getUser() async {
    final chat = await FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .doc(chatId)
        .get();
    final users = chat.get('users') as List? ?? [];
    final curetUserId = FirebaseAuth.instance.currentUser?.uid;
    if (curetUserId == null) return null;

    final userId = users.firstWhere((el) => el != curetUserId);
    final otherUser = ProUser.fromJson(
      (await FirebaseFirestore.instance
              .collection(FirebaseCollections.usersPath)
              .doc(userId)
              .get())
          .data(),
    );

    final chatDoc = await FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .doc(chatId)
        .get();

    final lastMessage = ChatModel.fromJson(chatDoc.data() ?? {}).messages?.last;

    return ChatTileData(
      user: otherUser,
      message: lastMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatTileData?>(
      future: _getUser(),
      builder: (context, init) {
        final data = init.data;
        if (!init.hasData || data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final imgPath = data.user?.imagePath;

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection(FirebaseCollections.chatPath)
              .doc(chatId)
              .snapshots(),
          builder: (context, snapshot) {
            final chatData = snapshot.data;
            if (!snapshot.hasData || chatData == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final chat = ChatModel.fromJson(chatData.data() ?? {});
            final _mes = chat.messages?.last;

            final date = DateTime.fromMillisecondsSinceEpoch(_mes?.time ?? 0);
            final time = DateFormat('HH:mm').format(date);

            return Hero(
              tag: chatId,
              child: BgContainer(
                action: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) {
                        return SinglChatPage(
                          chatId: chatId,
                          imgPath: imgPath,
                          contactName: data.user?.name,
                        );
                      },
                    ),
                  );
                },
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.akcentLight,
                    radius: 28,
                    backgroundImage:
                        imgPath != null ? NetworkImage(imgPath) : null,
                  ),
                  title: Text(
                    '${data.user?.name}',
                    style: const TextStyle(
                      color: AppColors.text,
                    ),
                  ),
                  subtitle: Text(
                    '${_mes?.content}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textInfoSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Icon(
                        Icons.done_all,
                        size: 16,
                        color: AppColors.akcentSecondaryLight,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChatTileData {
  final ProUser? user;
  final Message? message;

  ChatTileData({required this.user, required this.message});
}
