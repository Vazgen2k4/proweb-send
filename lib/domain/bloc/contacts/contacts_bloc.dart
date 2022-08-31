import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/chat_model.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/generated/intl/messages_en.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _strSub;

  ContactsBloc() : super(ContactsInitial()) {
    on<LoadContacts>(_load);
    on<StartChatWithContact>(_startMessageWithContact);

    _stream = FirebaseFirestore.instance
        .collection(FirebaseCollections.usersPath)
        .snapshots(includeMetadataChanges: true);

    _strSub = _stream.listen((_) => add(const LoadContacts()));
  }

  Future<void> _load(
    LoadContacts event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      final permission = await FlutterContacts.requestPermission();
      if (!permission) return;

      final _contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
        withAccounts: true,
      );

      final users = await _stream.first;
      final newState = _getContactsState(
        contacts: _contacts,
        users: users,
      );

      emit(newState);
    } catch (e) {
      if (kDebugMode) {
        print('[object] - Произошел пиздец');
      }
    }
  }

  // Получение разрешение на чтение контактов
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      final permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    }
    return permission;
  }

  ContactsLoaded _getContactsState({
    required List<Contact> contacts,
    required QuerySnapshot<Map<String, dynamic>> users,
  }) {
    final _users = users.docs
        .map<ProUser>((user) => ProUser.fromJson(user.data(), id: user.id));

    final deviceContacts = contacts.where((el) {
      return el.phones.isNotEmpty;
    }).map<String>((item) {
      return (item.phones.first.normalizedNumber);
    }).toList();

    final newContacts = _users.where((user) {
      return user.phone != null &&
          user.phone!.isNotEmpty &&
          deviceContacts.contains(user.phone!.replaceAll(' ', ''));
    }).toList();

    return ContactsLoaded(contacts: newContacts);
  }

  Future<void> _startMessageWithContact(
    StartChatWithContact event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      if (state is! ContactsLoaded) return;

      final myUid = FirebaseAuth.instance.currentUser?.uid;
      final otherUser = event.user;
      if (myUid == null || otherUser.id == null) return;

      final allChats = await FirebaseFirestore.instance
          .collection(FirebaseCollections.chatPath)
          .get();

      if (allChats.docs.isNotEmpty) {
        final chatsWithOtherUser = allChats.docs
            .map<ChatModel>(
              (chat) => ChatModel.fromJson(chat.data(), id: chat.id),
            )
            .where(
              (chat) =>
                  chat.users != null &&
                  chat.users!.contains(myUid) &&
                  chat.users!.contains(otherUser.id),
            )
            .toList();

        if (chatsWithOtherUser.isNotEmpty) {
          event.onDone != null ? event.onDone!(chatsWithOtherUser.first.id) : 0;
          return;
        }
      }

      final chat = ChatModel(
        id: '',
        messages: [
          Message(
            content: 'Вы начали общение в Prochat\n'
                'Просим соблюдать нормы морали',
            userId: 'admin',
            time: DateTime.now().millisecondsSinceEpoch,
            isAdminMessage: true,
          ),
        ],
        users: [myUid, otherUser.id!],
      );

      final chatDoc = await FirebaseFirestore.instance
          .collection(FirebaseCollections.chatPath)
          .add(chat.toJson());

      await _addChatToUser(userId: otherUser.id!, chatId: chatDoc.id);
      await _addChatToUser(userId: myUid, chatId: chatDoc.id);

      event.onDone != null ? event.onDone!(chatDoc.id) : 0;
    } catch (e) {
      if (kDebugMode) {
        print('[object] - Произошел пиздец');
      }
    }
  }

  Future<void> _addChatToUser({
    required String userId,
    required String chatId,
  }) async {
    final userData = await FirebaseFirestore.instance
        .collection(FirebaseCollections.usersPath)
        .doc(userId)
        .get();

    final user = ProUser.fromJson(
      userData.data(),
      id: userId,
    )..chats?.add(chatId);

    await FirebaseFirestore.instance
        .collection(FirebaseCollections.usersPath)
        .doc(userId)
        .update(user.toJson());
  }

  @override
  Future<void> close() {
    _strSub.cancel();
    return super.close();
  }
}
