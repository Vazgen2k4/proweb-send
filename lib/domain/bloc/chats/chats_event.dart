part of 'chats_bloc.dart';

abstract class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

class LoadChats extends ChatsEvent {
  const LoadChats();
}
class AddChats extends ChatsEvent {}

class SendMessage extends ChatsEvent {
  final String chatId;

  const SendMessage({required this.chatId});

  @override
  List<Object> get props => [chatId];
}
