import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/pro_contact.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _strSub;

  ContactsBloc() : super(ContactsInitial()) {
    on<LoadContacts>(_load);

    _stream = FirebaseFirestore.instance
        .collection(FirebaseCollections.usersPath)
        .snapshots(includeMetadataChanges: true);

    _strSub = _stream.listen((_) => add(const LoadContacts()));
  }

  Future<void> _load(
    LoadContacts event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      final permission = await _getContactPermission();
      if (!permission.isGranted) return;

      final _contacts = await ContactsService.getContacts(
        withThumbnails: false,
      );

      final users = await _stream.first;
      final newState = _getContactsState(
        contacts: _contacts,
        users: users,
      );

      emit(newState);
    } catch (e) {
      print('[object] - Произошел пиздец');
    }
  }

  // Получение разрешение на чтение контактов
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      final permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    }
    return permission;
  }

  ContactsLoaded _getContactsState({
    required List<Contact> contacts,
    required QuerySnapshot<Map<String, dynamic>> users,
  }) {
    final phones = users.docs.map<String>(
        (user) => (user.get('phone') as String? ?? '-1').replaceAll(' ', ''));

    final normalContacts = contacts.where((el) {
      return el.displayName != null &&
          el.phones != null &&
          el.phones!.isNotEmpty &&
          phones.contains(el.phones!.first.value!.replaceAll(' ', ''));
    }).toList();

    final newContacts = normalContacts.map<ProContact>((contact) {
      return ProContact(
        name: contact.displayName ?? 'error',
        phone: contact.phones?.first.value ?? 'error',
      );
    }).toList();

    return ContactsLoaded(contacts: newContacts);
  }

  @override
  Future<void> close() {
    _strSub.cancel();
    return super.close();
  }
}
