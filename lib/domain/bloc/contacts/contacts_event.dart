part of 'contacts_bloc.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object> get props => [];
}

class LoadContacts extends ContactsEvent {
  const LoadContacts();

  @override
  List<Object> get props => [];
}

class StartChatWithContact extends ContactsEvent {
  final ProUser user;
  final Function(String chatId)? onDone;
  const StartChatWithContact({required this.user, this.onDone});

  @override
  List<Object> get props => [user];
}
