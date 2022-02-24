import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthLogin extends AuthEvent {
  final Auth user;

  const AuthLogin(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Logged in successfully {user: $user}';
}

class AuthDataLoad extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LogOut extends AuthEvent {
  @override
  List<Object?> get props => [];
}
