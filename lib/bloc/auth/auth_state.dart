import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthSigningIn extends AuthState {}

class LogOutSuccess extends AuthState {}

class AuthDataLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthDataLoadSuccess extends AuthState {
  final Auth auth;

  const AuthDataLoadSuccess(this.auth);
  @override
  List<Object> get props => [auth];
}

class AuthOperationFailure extends AuthState {}
