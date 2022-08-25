import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final String chatId;
  final List<MessageModel> messages;
  final List<String> users;

  const ChatModel({
    required this.chatId,
    required this.messages,
    required this.users, 
  });


  @override
  List<Object?> get props => [chatId, messages, users];
}

class MessageModel extends Equatable {
  final String userId;
  final String title;
  final DateTime timeSend;

  const MessageModel({
    required this.userId,
    required this.title,
    required this.timeSend,
  });

  @override
  List<Object?> get props => [userId, timeSend, title];
}
