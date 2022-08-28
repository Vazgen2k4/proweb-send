
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
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
      return permissionStatus;
    } else {
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
  void initState() {
    super.initState();
    _getContactPermission();
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
      body: FutureBuilder<PermissionStatus>(builder: (context, d) {
        final dd = d.data;
        if (!d.hasData || dd == null) {
          if (dd == null || !d.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        if (dd.isDenied) {
          return FutureBuilder<List<Contact>>(
            future: ContactsService.getContacts(),
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data == null || !snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: AppColors.greySecondaryLight,
                    title: Text(
                      '${data[index].displayName}',
                      style: const TextStyle(color: AppColors.text),
                    ),
                    subtitle: Text(
                      '${data[index].phones?.first.value}',
                      style: const TextStyle(color: AppColors.text),
                    ),
                  );
                },
              );
            },
          );
        }

        return Text('data');
      }),
    );
  }
}
