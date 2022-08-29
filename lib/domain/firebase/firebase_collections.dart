import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
// import 'package:proweb_send/domain/providers/user_data_provider.dart';

abstract class FirebaseCollections {
  FirebaseCollections._();

  static const String usersPath = 'users';
  static const String chatPath = 'chats';

  static Future<void> addUserTo({
    String? userId,
    required Map<String, dynamic> userData,
  }) async {
    if (userId == null) return;

    final users = FirebaseFirestore.instance.collection(usersPath);
    await users.doc(userId).set(userData);
  }

  static Future<bool?> needRegistr({String? userId}) async {
    if (userId == null || userId.isEmpty) return null;

    final users = FirebaseFirestore.instance.collection(usersPath);
    final user = await users.doc(userId).get();

    final curentUser = ProUser.fromJson(user.data(), id: userId);

    return curentUser.name == null || curentUser.nikNameId == null;
  }

  static Future<bool> busyNikName({required String nikNameId}) async {
    final usersColection = FirebaseFirestore.instance.collection(usersPath);
    final usersSnapshot = await usersColection.get();
    final usersList = usersSnapshot.docs
        .map<ProUser>((item) => ProUser.fromJson(item.data(), id: item.id));

    final isBusy = usersList.any((_user) => _user.nikNameId == nikNameId);
    return isBusy;
  }
}
