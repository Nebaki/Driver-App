import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';

//import '../place.dart';

class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UsersLoadSuccess extends UserState {
  final User user;

  const UsersLoadSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class UsersDeleteSuccess extends UserState {
  final bool isSuccessfull;

  const UsersDeleteSuccess(this.isSuccessfull);

  @override
  List<Object> get props => [isSuccessfull];
}

class ImageUploadSuccess extends UserState {}

class UserPreferenceUploadSuccess extends UserState {}

class UserOperationFailure extends UserState {}

class UserPasswordChanged extends UserState {}

class UserPhoneNumbeChecked extends UserState {
  final bool phoneNumberExist;
  const UserPhoneNumbeChecked(this.phoneNumberExist);
  @override
  List<Object> get props => [phoneNumberExist];
}

class UserUnAuthorised extends UserState {}
