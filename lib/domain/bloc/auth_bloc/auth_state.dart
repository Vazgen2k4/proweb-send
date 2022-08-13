part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoaded extends AuthState {
  static final auth = FirebaseAuth.instance;
  static PhoneAuthCredential? credential;
  static String? verificationid;

  final bool hasAuth;
  final ProUser user;

  const AuthLoaded({
    required this.hasAuth,
    required this.user,
  });

  @override
  List<Object> get props => [hasAuth, user];
}


class UserPhoneData {
  final _phoneController = TextEditingController();
  TextEditingController get phoneController => _phoneController;
  final _smsController = TextEditingController();
  TextEditingController get smsController => _smsController;
  String _countryCode = '';
  String get countryCode => _countryCode;

  UserPhoneData();

  void dispose() {
    _phoneController.dispose();
    _smsController.dispose();
  }

  String get phone {
    final _code = _countryCode.trim();
    final _number = _phoneController.value.text.trim();
    return _code.replaceAll(' ', '') + _number.replaceAll(' ', '');
  }

  set countryCode(String? value) {
    _countryCode = value?.trim() ?? _countryCode;
  }
}