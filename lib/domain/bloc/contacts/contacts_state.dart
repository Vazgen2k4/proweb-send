part of 'contacts_bloc.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ProContact> contacts;

  const ContactsLoaded({
    required this.contacts,
  });

  @override
  List<Object> get props => [contacts];
}
