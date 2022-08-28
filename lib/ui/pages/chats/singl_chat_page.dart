import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:proweb_send/domain/bloc/chats/chats_bloc.dart';
import 'package:proweb_send/domain/bloc/message/message_bloc.dart';
import 'package:proweb_send/domain/bloc/settings_bloc/settings_bloc.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/chat_model.dart';
import 'package:proweb_send/domain/models/settings_model.dart';
import 'package:proweb_send/ui/pages/settings/settings_theme_page.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

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
    return Scaffold(
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
          Hero(
            tag: chatId,
            child: CircleAvatar(
              backgroundColor: AppColors.akcentLight,
              radius: 24,
              backgroundImage: imgPath != null ? NetworkImage(imgPath!) : null,
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection(FirebaseCollections.chatPath)
            .doc(chatId)
            .get(),
        builder: (context, init) {
          if (init.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
            initialData: init.data,
            stream: FirebaseFirestore.instance
                .collection(FirebaseCollections.chatPath)
                .doc(chatId)
                .snapshots(includeMetadataChanges: true),
            builder: (context, snapshot) {
              final chatData = snapshot.data;

              if (chatData == null || !snapshot.hasData) {
                return const Center();
              }
              final chat = ChatModel.fromJson(
                chatData.data() ?? {},
                id: chatId,
              );
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
          );
        },
      ),
      bottomSheet: Container(
        color: AppColors.greyPrimary,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
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
            EnterInput(chatId: chatId),
            const SizedBox(width: 8),
            SendSwichButton(chatId: chatId),
          ],
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

        return ChatList(
          messages: messages,
          settings: state.settings,
        );
      },
    );
  }
}

class ChatList extends StatefulWidget {
  final SettingsModel settings;
  const ChatList({
    Key? key,
    required this.messages,
    required this.settings,
  }) : super(key: key);

  final List<Message> messages;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Message> _reverse = [];

  @override
  void initState() {
    _reverse = widget.messages.reversed.toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: ChatController.myListKey,
      reverse: true,
      controller: ChatController.listController,
      padding: const EdgeInsets.only(
        bottom: 100,
        left: 16,
        top: 16,
        right: 16,
      ),
      initialItemCount: _reverse.length,
      itemBuilder: (context, index, animation) {
        final message = _reverse[index];
        final myUid = FirebaseAuth.instance.currentUser?.uid;
        final date = DateTime.fromMillisecondsSinceEpoch(message.time ?? 0);

        final time = DateFormat('HH:mm').format(date);
        final tween = Tween(begin: 0.0, end: 1.0);
        return FadeTransition(
          opacity: animation.drive(tween),
          child: MessageWidget(
            message: message.content ?? 'Ошибка',
            itsMe: myUid == message.userId,
            time: time,
            settings: widget.settings,
          ),
        );
      },
    );
  }
}

class EnterInput extends StatefulWidget {
  final String chatId;
  const EnterInput({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  State<EnterInput> createState() => _EnterInputState();
}

class _EnterInputState extends State<EnterInput> {
  bool haveMessage = false;

  @override
  void initState() {
    super.initState();
    haveMessage = !ChatController.textIsEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: ChatController.textController,
        maxLines: 10,
        minLines: 1,
        style: const TextStyle(fontSize: 16, color: AppColors.text),
        cursorColor: AppColors.text,
        decoration: const InputDecoration(
          floatingLabelStyle: TextStyle(color: AppColors.text),
          labelStyle: TextStyle(color: AppColors.greySecondaryLight),
          labelText: 'Сообщение',
          contentPadding: EdgeInsets.only(
            bottom: 12,
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            haveMessage = value.trim().isNotEmpty;
          });
        },
      ),
    );
  }
}

class SendSwichButton extends StatefulWidget {
  final String chatId;
  const SendSwichButton({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  State<SendSwichButton> createState() => _SendSwichButtonState();
}

class _SendSwichButtonState extends State<SendSwichButton> {
  bool canSend = true;

  @override
  void initState() {
    super.initState();
    ChatController.textController.addListener(() {
      if (mounted) {
        canSend = ChatController.textIsEmpty;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _btns = <IconButton>[
      IconButton(
        key: const ValueKey(1),
        onPressed: () {},
        icon: const Icon(
          Icons.sentiment_satisfied_alt,
          color: AppColors.textInfo,
          size: 30,
        ),
      ),
      IconButton(
        key: const ValueKey(2),
        onPressed: () {
          context.read<MessageBloc>().add(SendMessage(chatId: widget.chatId));
        },
        icon: const Icon(
          Icons.send_rounded,
          color: AppColors.text,
        ),
      ),
    ];

    return AnimatedSwitcher(
      // layoutBuilder: ,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: canSend ? _btns.first : _btns.last,
      // crossFadeState: stateFade,
      duration: const Duration(milliseconds: 150),
    );
  }
}

/* AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: haveMessage ? 1 : 0,
            child: 
          ),
         */
