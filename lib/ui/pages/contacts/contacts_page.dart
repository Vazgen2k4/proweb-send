import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      print(permission);
      return permissionStatus;
    } else {
      print(permission);
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Контакты',
          style: TextStyle(
            color: AppColors.text,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection(FirebaseCollections.usersPath)
              .snapshots(),
          builder: (context, allUsers) {
            final usersData = allUsers.data;

            if (!allUsers.hasData || usersData == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final phonesFomFire = usersData.docs.map<String>((e) {
              return (e.get('phone') as String? ?? '-1').replaceAll(' ', '');
            }).toList();

            print(phonesFomFire);

            return FutureBuilder<PermissionStatus>(
                future: _getContactPermission(),
                builder: (context, d) {
                  final dd = d.data;
                  print(dd);

                  if (!d.hasData || dd == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (dd.isGranted) {
                    return FutureBuilder<List<Contact>>(
                      future: ContactsService.getContacts(),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        if (data == null || !snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final normalContact = data
                            .where(
                              (el) =>
                                  el.displayName != null &&
                                  el.phones != null &&
                                  el.phones!.isNotEmpty &&
                                  phonesFomFire.contains(el.phones!.first.value!
                                      .replaceAll(' ', '')),
                            )
                            .toList();

                      

                        return ListView.separated(
                          itemCount: normalContact.length,
                          padding: EdgeInsets.all(16),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final contact = normalContact[index];
                            final phones = contact.phones;
                            // final img = usersData.docs.firstWhere()

                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: AppColors.message,
                              ),
                              tileColor: AppColors.greySecondaryLight,
                              title: Text(
                                '${contact.displayName}',
                                style: const TextStyle(color: AppColors.text),
                              ),
                              subtitle: Text(
                                '${phones?.first.value}',
                                style: const TextStyle(color: AppColors.text),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  return Text('data');
                });
          }),
    );
  }
}
