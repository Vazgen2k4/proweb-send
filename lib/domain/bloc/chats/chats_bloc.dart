import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/chat_model.dart';
import 'package:proweb_send/domain/models/pro_user.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc() : super(ChatsInitial()) {
    on<LoadChats>(_load);
    on<SendMessage>(_send);
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
    final chats = ProUser.fromJson(json).chats ?? [];

    emit(ChatsLoaded(chats: chats));
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
    ChatController.textController.notifyListeners();

    await FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .doc(event.chatId)
        .set(chat.toJson());

    await ChatController.jumpDown(offset: -100);
  }
}
