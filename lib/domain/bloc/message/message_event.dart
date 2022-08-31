part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessage extends MessageEvent {
  const LoadMessage();
}

class SendMessage extends MessageEvent {
  final String chatId;

  const SendMessage({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class ReadMessage extends MessageEvent {
  final int index;
  final Message message;

  const ReadMessage({
    required this.index,
    required this.message,
  });

  @override
  List<Object> get props => [ index, message];
}
