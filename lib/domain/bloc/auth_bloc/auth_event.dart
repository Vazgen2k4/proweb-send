part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoadAuth extends AuthEvent {
  final bool hasAuth;

  const LoadAuth({required this.hasAuth});

  @override
  List<Object?> get props => [hasAuth];
}

class AuthWithPhone extends AuthEvent {
  final String phone;

  const AuthWithPhone({required this.phone});

  @override
  List<Object> get props => [phone];
}

class AuthVerifirePhone extends AuthEvent {
  final String sms;

  const AuthVerifirePhone({required this.sms});

  @override
  List<Object> get props => [sms];
}

class AuthCreateAccount extends AuthEvent {
  final PlatformFile? image;
  final ProUser user;

  const AuthCreateAccount({this.image, required this.user});

  @override
  List<Object?> get props => [image, user];
}

class AuthLogInAccount extends AuthEvent {
  final ProUser user;
  const AuthLogInAccount({required this.user});

  @override
  List<Object?> get props => [user];
}
