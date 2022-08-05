part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthWithNumberState extends AuthState {}

class AuthWithGoogleState extends AuthState {}

class AuthWith extends AuthState {}
