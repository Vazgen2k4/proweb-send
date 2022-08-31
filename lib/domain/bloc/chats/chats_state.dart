part of 'chats_bloc.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

class ChatsInitial extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<ChatTileData> chats;
  final List<ChatModel> chatsData;

  const ChatsLoaded({
    required this.chats,
    required this.chatsData,
  });

  @override
  List<Object> get props => [chats];

  ChatsLoaded copyWith({
    List<ChatTileData>? chats,
    List<ChatModel>? chatsData,
  }) {
    return ChatsLoaded(
      chats: chats ?? this.chats,
      chatsData: chatsData ?? this.chatsData,
    );
  }
}

class ChatTileData {
  final ProUser? user;
  final Message? message;
  final int notVisibleMessage;

  ChatTileData({
    required this.user,
    required this.message,
    required this.notVisibleMessage,
  });
}
