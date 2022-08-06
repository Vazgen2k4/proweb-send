import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';

// class AuthProvider extends ChangeNotifier {
//   AuthPhoneModel phoneModel = AuthPhoneModel();
// }

// class AuthPhoneModel {

//   final phoneController = TextEditingController();
//   String _code = '';

class UserDataProvider {
  final pref = SharedPreferences.getInstance();

  Future<UserData> loadValue() async {
    final _pref = await pref;

    final String? name = _pref.getString(UserDataKeys.name);
    final String? phone = _pref.getString(UserDataKeys.phone);
    final String? countryCode = _pref.getString(UserDataKeys.countryCode);
    final String? userName = _pref.getString(UserDataKeys.userName);
    final int id = _pref.getInt(UserDataKeys.id) ?? -1;

    return UserData(
      countryCode: countryCode,
      userName: userName,
      phone: phone,
      name: name,
      id: id,
    );
  }

  Future<void> setValue(UserData user) async {
    final _pref = await pref;

    await _pref.setString(UserDataKeys.name, user.name ?? 'error');
    await _pref.setString(UserDataKeys.phone, user.phone ?? 'error');
    await _pref.setString(UserDataKeys.userName, user.userName ?? 'error');
    await _pref.setInt(UserDataKeys.id, user.id);
    await _pref.setString(
        UserDataKeys.countryCode, user.countryCode ?? 'error');
  }
}

class UserData extends Equatable {
  final String? name;
  final String? phone;
  final String? countryCode;
  final String? userName;
  final int id;

  const UserData({
    this.countryCode,
    this.userName,
    this.phone,
    this.name,
    this.id = -1,
  });

  @override
  List<Object?> get props => [name, phone, countryCode, userName, id];

  UserData copyWith({
    String? countryCode,
    String? userName,
    String? phone,
    String? name,
    int? id,
  }) {
    return UserData(
      countryCode: countryCode ?? this.countryCode,
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      userName: userName ?? this.userName,
    );
  }
}

abstract class UserDataKeys {
  static const String name = '--name--';
  static const String phone = '--phone--';
  static const String countryCode = '--country-code--';
  static const String userName = '--user-name--';
  static const String id = '--id--';
}
