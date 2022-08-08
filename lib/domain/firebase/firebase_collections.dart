import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Firebasecollections {
  Firebasecollections._();

  static const String usersPath = 'users';

  static Future<void> addUserTo({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    final users = FirebaseFirestore.instance.collection(usersPath);
    await users.doc(userId).set(userData);
  }
}
