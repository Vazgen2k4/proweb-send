import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/chat_model.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final String curentChatid;

  ///[curentChatid] ID - чата для которого запускаем стрим

  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;
  late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      _streamSub;
  MessageBloc(this.curentChatid) : super(MessageInitial()) {
    on<LoadMessage>(_load);
    on<SendMessage>(_send);
    on<ReadMessage>(_read);

    _stream = FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .doc(curentChatid)
        .snapshots(includeMetadataChanges: true);

    _streamSub = _stream.listen((_) => add(const LoadMessage()));
  }

  Future<void> _load(
    LoadMessage event,
    Emitter<MessageState> emit,
  ) async {
    final document = await _stream.first;
    final chat = ChatModel.fromJson(document.data() ?? {}, id: curentChatid);

    emit(MessageLoaded(chat: chat));
  }

  Future<void> _send(
    SendMessage event,
    Emitter<MessageState> emit,
  ) async {
    if (this.state is! MessageLoaded) return;
    final state = this.state as MessageLoaded;

    if (ChatController.textIsEmpty) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final mess = Message(
      time: DateTime.now().millisecondsSinceEpoch,
      content: ChatController.textController.value.text,
      userId: uid,
      isAdminMessage: false,
      visible: false,
    );

    final chat = state.chat;

    chat.messages?.insert(0, mess);

    ChatController.textController.clear();

    await FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .doc(event.chatId)
        .set(chat.toJson());
  }

  Future<void> _read(
    ReadMessage event,
    Emitter<MessageState> emit,
  ) async {
    final message = event.message..visible = true;

    final messDoc = await FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .doc(curentChatid)
        .get();

    final chat = ChatModel.fromJson(messDoc.data() ?? {}, id: curentChatid);
    chat.messages?[event.index] = message;

    await FirebaseFirestore.instance
        .collection(FirebaseCollections.chatPath)
        .doc(curentChatid)
        .update(chat.toJson());
  }

  @override
  Future<void> close() {
    _streamSub.cancel();
    return super.close();
  }
}
