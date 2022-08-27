part of 'chats_bloc.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

class ChatsInitial extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<String> chats;

  const ChatsLoaded({required this.chats});

  @override
  List<Object> get props => [chats];

  ChatsLoaded copyWith({List<String>? chats}) {
    return ChatsLoaded(chats: chats ?? this.chats);
  }
}
