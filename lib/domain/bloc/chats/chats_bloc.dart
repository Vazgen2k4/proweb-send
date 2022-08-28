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
        .map<ChatModel>((chatDoc) => ChatModel.fromJson(
              chatDoc.data(),
              id: chatDoc.id,
            ))
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

 

  @override
  Future<void> close() {
    chatsStreamSub.cancel();
    usersStreamSub.cancel();
    return super.close();
  }
}
