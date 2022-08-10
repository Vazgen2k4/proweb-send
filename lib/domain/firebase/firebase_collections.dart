import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proweb_send/domain/providers/user_data_provider.dart';

abstract class FirebaseCollections {
  FirebaseCollections._();

  static const String usersPath = 'users';

  static Future<void> addUserTo({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    final users = FirebaseFirestore.instance.collection(usersPath);
    await users.doc(userId).set(userData);
  }

  static Future<bool> needRegistr({required String userId}) async {
    final users = FirebaseFirestore.instance.collection(usersPath);
    final user = await users.doc(userId).get();

    final curentUser = UserData.fromJson(user.data());

    return curentUser.name == null || curentUser.userName == null;
  }
}
