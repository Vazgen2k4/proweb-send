import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proweb_send/domain/bloc/contacts/contacts_bloc.dart';
import 'package:proweb_send/ui/pages/chats/singl_chat_page.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

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
      body: const ContactsPageContent(),
    );
  }
}

class ContactsPageContent extends StatelessWidget {
  const ContactsPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      buildWhen: (previous, current) => true,
      builder: (context, state) {
        if (state is! ContactsLoaded) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final contacts = state.contacts;

        if (contacts.isEmpty) {
          return const Center(
            child: Text(
              'У вас нет актуальных контактов',
              style: TextStyle(
                fontSize: 19,
                color: AppColors.text,
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: contacts.length,
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final contact = contacts[index];

            return ListTile(
              onTap: () {
                context.read<ContactsBloc>().add(
                      StartChatWithContact(
                        user: contact,
                        onDone: (chatId) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder: (_, __, ___) {
                                return SinglChatPage(
                                  chatId: chatId,
                                  imgPath: contact.imagePath,
                                  contactName: contact.name,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
              },
              leading: (contact.imagePath != null)
                  ? CircleAvatar(
                      backgroundColor: AppColors.message,
                      backgroundImage: NetworkImage(contact.imagePath!),
                    )
                  : CircleAvatar(
                      backgroundColor: AppColors.message,
                      child: Text(
                        (contact.name ?? '404').substring(0, 1).toUpperCase(),
                      ),
                    ),
              tileColor: AppColors.greySecondaryLight,
              title: Text(
                '${contact.name}',
                style: const TextStyle(color: AppColors.text),
              ),
              subtitle: Text(
                '${contact.phone}',
                style: const TextStyle(color: AppColors.text),
              ),
            );
          },
        );
      },
    );
  }
}

/* StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

          return FutureBuilder<PermissionStatus>(
            future: _getContactPermission(),
            builder: (context, d) {
              final dd = d.data;

              if (!d.hasData || dd == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (dd.isGranted) {
                return FutureBuilder<List<Contact>>(
                  future: ,
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    if (data == null || !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    

                    
                      },
                    );
                  },
                );
              }
              return Text('data');
            },
          );
        },
      ), 
      
      
      
      
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (!snapshot.hasData || data == null) {
            return const Center();
          }
          return
      
      
      
      
      
      
      
      
      
      
      
      */