import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:proweb_send/domain/bloc/settings_bloc/settings_bloc.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/chat_model.dart';
import 'package:proweb_send/ui/pages/settings/settings_theme_page.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/bg_container.dart';

class SinglChatPage extends StatelessWidget {
  final String chatId;
  final String? imgPath;
  final String? contactName;
  const SinglChatPage({
    Key? key,
    required this.chatId,
    required this.imgPath,
    required this.contactName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: chatId,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Чаты',
            style: TextStyle(
              fontSize: 22,
              height: 28 / 22,
              color: AppColors.text,
            ),
          ),
          actions: [
            CircleAvatar(
              backgroundColor: AppColors.akcentLight,
              radius: 24,
              backgroundImage: imgPath != null ? NetworkImage(imgPath!) : null,
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection(FirebaseCollections.chatPath)
              .doc(chatId)
              .snapshots(includeMetadataChanges: true),
          builder: (context, snapshot) {
            final chatData = snapshot.data;

            print(snapshot.hasData);
            if (chatData == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chat = ChatModel.fromJson(chatData.data() ?? {});
            final messages = chat.messages ?? [];

            if (messages.isEmpty) {
              return Center(
                child: Text(
                  'Начните общение с пользователем\n $contactName',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.text,
                  ),
                ),
              );
            }

            return ChatMessageWidget(
              messages: messages,
            );
          },
        ),
        bottomSheet: Container(
          color: AppColors.greyPrimary,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_circle_outline_outlined,
                  color: AppColors.textInfo,
                  size: 30,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.sentiment_satisfied_alt,
                  color: AppColors.textInfo,
                  size: 30,
                ),
              ),
              const SizedBox(width: 8),
              EnterInput(chatId: chatId),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final List<Message> messages;
  const ChatMessageWidget({
    Key? key,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsBlocState>(
      builder: (context, state) {
        if (state is! SettingsBlocLoded) {
          return const SizedBox();
        }

        return AnimatedList(
          padding: const EdgeInsets.only(
            bottom: 100,
            left: 16,
            top: 16,
            right: 16,
          ),
          // separatorBuilder: (context, index) => const SizedBox(height: 16),
          initialItemCount: messages.length,
          itemBuilder: (context, index, animation) {
            final message = messages[index];
            final myUid = FirebaseAuth.instance.currentUser?.uid;
            final date = DateTime.fromMillisecondsSinceEpoch(message.time ?? 0);

            final time = DateFormat('HH:mm').format(date);

            return MessageWidget(
              message: message.content ?? 'Ошибка',
              itsMe: myUid == message.userId,
              time: time,
              settings: state.settings,
            );
          },
        );
      },
    );
  }
}

class EnterInput extends StatelessWidget {
  final String chatId;
  const EnterInput({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        style: const TextStyle(fontSize: 16, color: AppColors.text),
        decoration: InputDecoration(
          floatingLabelStyle: const TextStyle(color: Colors.transparent),
          fillColor: AppColors.greySecondaryLight,
          filled: true,
          labelText: 'Сообщение',
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) async {
          if (value.trim().isEmpty) return;
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid == null) return;
          final mess = Message(
            time: DateTime.now().millisecondsSinceEpoch,
            content: value,
            userId: uid,
          );

          final chatData = await FirebaseFirestore.instance
              .collection(FirebaseCollections.chatPath)
              .doc(chatId)
              .get();

          final chat = ChatModel.fromJson(chatData.data() ?? {});
          chat.messages?.add(mess);

          await FirebaseFirestore.instance
              .collection(FirebaseCollections.chatPath)
              .doc(chatId)
              .set(chat.toJson());
        },
      ),
    );
  }
}
