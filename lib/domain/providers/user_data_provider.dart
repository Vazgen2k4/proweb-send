// import 'package:equatable/equatable.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserDataProvider {
//   final pref = SharedPreferences.getInstance();

//   Future<UserData> loadValue() async {
//     final _pref = await pref;

//     final String? name = _pref.getString(UserDataKeys.name);
//     final String? phone = _pref.getString(UserDataKeys.phone);
//     final String? userName = _pref.getString(UserDataKeys.userName);
//     final String? email = _pref.getString(UserDataKeys.email);
//     final String? descr = _pref.getString(UserDataKeys.descr);
//     final String? id = _pref.getString(UserDataKeys.id);

//     return UserData(
//       userName: userName,
//       phone: phone,
//       email: email,
//       descr: descr,
//       name: name,
//       id: id,
//     );
//   }

//   Future<void> setValue(UserData user) async {
//     await _setData<String?>(key: UserDataKeys.id, value: user.id);
//     await _setData<String?>(key: UserDataKeys.name, value: user.name);
//     await _setData<String?>(key: UserDataKeys.phone, value: user.phone);
//     await _setData<String?>(key: UserDataKeys.userName, value: user.userName);
//     await _setData<String?>(key: UserDataKeys.descr, value: user.descr);
//     await _setData<String?>(key: UserDataKeys.email, value: user.email);
//   }

//   Future<void> _setData<T>({
//     required T value,
//     required String key,
//   }) async {
//     if (value == null) return;

//     if (value is String) {
//       await (await pref).setString(key, value);
//     }
//   }
// }

// class UserData extends Equatable {
//   final String? name;
//   final String? phone;
//   final String? userName;
//   final String? email;
//   final String? descr;
//   final String? id;

//   const UserData({
//     this.userName,
//     this.phone,
//     this.email,
//     this.descr,
//     this.name,
//     this.id,
//   });

//   // Конструктор который не создаёт объект а возвращает новый
//   factory UserData.fromJson(Map<String, dynamic>? json) {
//     return UserData(
//       name: json?['name'],
//       phone: json?['phone'],
//       descr: json?['descr'],
//       userName: json?['nikNameId'],
//       email: json?['email'],
//     );
//   }

//   UserData copyWith({
//     String? userName,
//     String? phone,
//     String? descr,
//     String? email,
//     String? name,
//     String? id,
//   }) {
//     return UserData(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       phone: phone ?? this.phone,
//       userName: userName ?? this.userName,
//       descr: descr ?? this.descr,
//       email: email ?? this.email,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'phone': phone,
//       'nikNameId': userName,
//       'email': email,
//       'descr': descr,
//     };
//   }

//   @override
//   List<Object?> get props {
//     return [name, phone, userName, id, descr, email];
//   }
// }

// abstract class UserDataKeys {
//   static const String name = '--name--';
//   static const String phone = '--phone--';
//   static const String userName = '--user-name--';
//   static const String email = '--user-email--';
//   static const String descr = '--user-descr--';
//   static const String id = '--id--';
//   static const String hasAuth = '--auth--';
// }

// class UserPhoneData {
//   final _phoneController = TextEditingController();
//   TextEditingController get phoneController => _phoneController;
//   final _smsController = TextEditingController();
//   TextEditingController get smsController => _smsController;
//   String _countryCode = '';
//   String get countryCode => _countryCode;

//   UserPhoneData();

//   void dispose() {
//     _phoneController.dispose();
//     _smsController.dispose();
//   }

//   String get phone {
//     final _code = _countryCode.trim();
//     final _number = _phoneController.value.text.trim();
//     return _code.replaceAll(' ', '') + _number.replaceAll(' ', '');
//   }

//   set countryCode(String? value) {
//     _countryCode = value?.trim() ?? _countryCode;
//   }
// }

// class UserCreateData {
//   final _nameController = TextEditingController();
//   TextEditingController get nameController => _nameController;
//   final _descrController = TextEditingController();
//   TextEditingController get descrController => _descrController;
//   final _userNameController = TextEditingController();
//   TextEditingController get userNameController => _userNameController;
//   PlatformFile? _img;
//   PlatformFile? get img => _img;

//   UserCreateData();

//   void dispose() {
//     _nameController.dispose();
//     _descrController.dispose();
//     _userNameController.dispose();
//   }

//   Future<PlatformFile?> selectImage() async {
//     final res = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (res == null) return null;
//     _img = res.files.first;
//     return _img;
//   }
// }

// class UserCreateErros extends Equatable {
//   final bool userNameBusy;
//   final bool userNameEmpty;
//   final bool nameEmpty;

//   const UserCreateErros({
//     this.nameEmpty = false,
//     this.userNameBusy = false,
//     this.userNameEmpty = false,
//   });

//   @override
//   List<Object?> get props => [nameEmpty, userNameBusy, userNameEmpty];

//   UserCreateErros copyWith({
//     bool? nameEmpty,
//     bool? userNameBusy,
//     bool? userNameEmpty,
//   }) {
//     return UserCreateErros(
//       nameEmpty: nameEmpty ?? this.nameEmpty,
//       userNameBusy: userNameBusy ?? this.userNameBusy,
//       userNameEmpty: userNameEmpty ?? this.userNameEmpty,
//     );
//   }

//   bool get hasErrors => userNameBusy || nameEmpty || userNameEmpty;
// }
