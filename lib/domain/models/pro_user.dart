import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:proweb_send/generated/l10n.dart';

class ProUser extends Equatable {
  static final controller = ProUserController();

  final String? name;
  final String? phone;
  final String? nikNameId;
  final String? descr;
  final String? imagePath;
  final String? id;

  const ProUser({
    this.nikNameId,
    this.phone,
    this.imagePath,
    this.descr,
    this.name,
    this.id,
  });

  factory ProUser.fromJson(Map<String, dynamic>? json) {
    return ProUser(
      name: json?['name'],
      imagePath: json?['imagePath'],
      phone: json?['phone'],
      descr: json?['descr'],
      nikNameId: json?['nikNameId'],
    );
  }

  ProUser copyWith({
    String? nikNameId,
    String? imagePath,
    String? phone,
    String? descr,
    String? email,
    String? name,
    String? id,
  }) {
    return ProUser(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      nikNameId: nikNameId ?? this.nikNameId,
      descr: descr ?? this.descr,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'nikNameId': nikNameId,
      'descr': descr,
      'imagePath': imagePath,
    };
  }

  Map<String, String?> toDataInfo(BuildContext context) {
    return {
      S.of(context).number_telephone: phone,
      S.of(context).nik_name: nikNameId,
      S.of(context).bio: descr,
    };
  }

  @override
  List<Object?> get props {
    return [name, phone, nikNameId, id, descr, imagePath];
  }
}

class ProUserController {
  // Контроллер имени
  final _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;
  // Контроллер описания
  final _descrController = TextEditingController();
  TextEditingController get descrController => _descrController;
  // Контроллер уникального никнейма
  final _userNikNameController = TextEditingController();
  TextEditingController get userNikNameController => _userNikNameController;
  // Аватарка пользователя
  PlatformFile? _img;
  PlatformFile? get img => _img;

  // Контроллер номера телефона (Без кода страны)
  final _phoneController = TextEditingController();
  TextEditingController get phoneController => _phoneController;
  // Контроллер смс кода
  final _smsController = TextEditingController();
  TextEditingController get smsController => _smsController;
  // Значение кода страны для авторизации
  String _countryCode = '';
  String get countryCode => _countryCode;
  // Значение кода страны для авторизации
  String? _uid;
  String? get uid => _uid;

  // Гетер уже готового номера телефона
  String get phone {

    final _code = _countryCode.trim();
    final _number = _phoneController.value.text.trim();
    return _code.replaceAll(' ', '') + _number.replaceAll(' ', '');
  }

  // Сетер кода страны
  set countryCode(String? value) {
    _countryCode = value?.trim() ?? _countryCode;
  }

  // Сетер кода страны
  set uid(String? value) {
    _uid = value?.trim() ?? _countryCode;
  }

  // Полное очищение всех контроллеров
  void clear() {
    _nameController.clear();
    _descrController.clear();
    _userNikNameController.clear();

    _phoneController.clear();
    _smsController.clear();
  }

  // Полное ОТКЛЮЧЕНИЕ всех кнтроллеров
  void dispose() {
    _nameController.dispose();
    _descrController.dispose();
    _userNikNameController.dispose();

    _phoneController.dispose();
    _smsController.dispose();
  }

  // Выбор изображения из галлереи и не только
  Future<PlatformFile?> selectImage() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image);
    if (res == null) return null;
    _img = res.files.first;
    return _img;
  }
}

class ProUserErros extends Equatable {
  final bool userNameBusy;
  final bool userNameEmpty;
  final bool nameEmpty;

  const ProUserErros({
    this.nameEmpty = false,
    this.userNameBusy = false,
    this.userNameEmpty = false,
  });

  @override
  List<Object?> get props => [nameEmpty, userNameBusy, userNameEmpty];

  ProUserErros copyWith({
    bool? nameEmpty,
    bool? userNameBusy,
    bool? userNameEmpty,
  }) {
    return ProUserErros(
      nameEmpty: nameEmpty ?? this.nameEmpty,
      userNameBusy: userNameBusy ?? this.userNameBusy,
      userNameEmpty: userNameEmpty ?? this.userNameEmpty,
    );
  }

  bool get hasErrors => userNameBusy || nameEmpty || userNameEmpty;
}
