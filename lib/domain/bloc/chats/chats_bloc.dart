import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/chat_model.dart';
import 'package:proweb_send/domain/models/pro_user.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      chatsStreamSub;
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> usersStream;
  late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      usersStreamSub;

  ChatsBloc() : super(ChatsInitial()) {
    on<LoadChats>(_load);
    on<SendMessage>(_send);

    usersStream = FirebaseFirestore.instance
        .collection(FirebaseCollections.usersPath)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots();

    usersStreamSub = usersStream.listen((_) => add(const LoadChats()));

    chatsStream = FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .snapshots();

    chatsStreamSub = chatsStream.listen((_) => add(const LoadChats()));
  }

  Future<void> _load(
    LoadChats event,
    Emitter<ChatsState> emit,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final document = await FirebaseFirestore.instance
        .collection(FirebaseCollections.usersPath)
        .doc(uid)
        .get();

    final json = document.data() ?? {};
    final _chats = ProUser.fromJson(json).chats ?? [];

    final allChats = await FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .get();

    final sortChatsData = allChats.docs
        .where((chatDoc) => _chats.contains(chatDoc.id))
        .map<ChatModel>((chatDoc) => ChatModel.fromJson(chatDoc.data()))
        .toList();

    final allUsers = await FirebaseFirestore.instance
        .collection(FirebaseCollections.usersPath)
        .get();

    final chatsTileData = sortChatsData.map<ChatTileData>((chatModel) {
      final otherUserId = chatModel.users?.firstWhere((user) => user != uid);

      final otherUserDoc =
          allUsers.docs.firstWhere((user) => user.id == otherUserId);

      final otherUser = ProUser.fromJson(otherUserDoc.data());

      return ChatTileData(
        message: chatModel.messages?.last,
        user: otherUser,
      );
    }).toList();

    emit(ChatsLoaded(
      chats: chatsTileData,
      chatsData: sortChatsData,
    ));
  }

  Future<void> _send(
    SendMessage event,
    Emitter<ChatsState> emit,
  ) async {
    if (ChatController.textIsEmpty) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final mess = Message(
      time: DateTime.now().millisecondsSinceEpoch,
      content: ChatController.textController.value.text,
      userId: uid,
    );

    final chatData = await FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .doc(event.chatId)
        .get();

    final chat = ChatModel.fromJson(chatData.data() ?? {});
    chat.messages?.add(mess);

    ChatController.textController.clear();

    await FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .doc(event.chatId)
        .set(chat.toJson());

    await ChatController.jumpDown(offset: -100);
  }

  @override
  Future<void> close() {
    chatsStreamSub.cancel();
    usersStreamSub.cancel();
    return super.close();
  }
}
