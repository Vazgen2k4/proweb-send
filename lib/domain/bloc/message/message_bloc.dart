import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/chat_model.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitial()) {
    on<LoadMessage>(_load);
    on<SendMessage>(_send);
  }

  Future<void> _load(
    LoadMessage event,
    Emitter<MessageState> emit,
  ) async {
    
  }

  Future<void> _send(
    SendMessage event,
    Emitter<MessageState> emit,
  ) async {
    if (this.state is! MessageLoad) return;
    final state = this.state as MessageLoad;
    
    
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

    final chat = ChatModel.fromJson(chatData.data() ?? {}, id: event.chatId);
    chat.messages?.add(mess);

    ChatController.textController.clear();

    await FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .doc(event.chatId)
        .set(chat.toJson());

    if (chat.messages != null) {
      ChatController.myListKey.currentState?.insertItem(
          chat.messages!.length - 1,
          duration: const Duration(milliseconds: 300));
    }

    await ChatController.jumpDown(offset: -100);
  }
}
