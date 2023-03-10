import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/repository/repositories.dart';
import 'bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserLoading());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserCreate) {
      yield UserLoading();
      try {
        final users = await userRepository.createPassenger(event.user);
        yield UsersLoadSuccess(users);
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield UserUnAuthorised();
        } else {
          yield UserOperationFailure();
        }
      }
    }

    if (event is UserUpdate) {
      yield UserLoading();
      try {
        final passenger = await userRepository.updatePassenger(event.user);
        yield UsersLoadSuccess(passenger);
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield UserUnAuthorised();
        } else {
          yield UserOperationFailure();
        }
      }
    }

    if (event is UserPreferenceUpdate) {
      yield UserLoading();
      try {
        await userRepository.updatePreference(event.user);
        yield UserPreferenceUploadSuccess();
      } catch (_) {
        yield UserOperationFailure();
      }
    }

    if (event is UserDelete) {
      try {
        await userRepository.deletePassenger(event.user.id!);
        yield const UsersDeleteSuccess(true);
      } catch (_) {
        yield UserOperationFailure();
      }
    }

    // if (event is UploadProfile) {
    //   yield UserLoading();

    //   try {
    //     await userRepository.uploadProfilePicture(event.file);
    //     yield ImageUploadSuccess();
    //   } catch (_) {
    //     yield UserOperationFailure();
    //   }
    // }

    if (event is UserLoadById) {
      yield UserLoading();

      try {
        final user = await userRepository.getUserById(event.id);
        yield UsersLoadSuccess(user);
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield UserUnAuthorised();
        } else {
          yield UserOperationFailure();
        }
      }
    }

    if (event is UserChangePassword) {
      yield UserLoading();

      try {
        await userRepository.changePassword(event.passwordInfo);
        yield UserPasswordChanged();
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield UserUnAuthorised();
        } else {
          yield UserOperationFailure();
        }
      }
    }
    if (event is UserForgetPassword) {
      yield UserLoading();

      try {
        await userRepository.forgetPassword(event.forgetPasswordInfo);
        yield UserPasswordChanged();
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield UserUnAuthorised();
        } else {
          yield UserOperationFailure();
        }
      }
    }

    if (event is UserCheckPhoneNumber) {
      yield UserLoading();

      try {
        final phoneNumberExist =
            await userRepository.checkPhoneNumber(event.phoneNumber);
        yield UserPhoneNumbeChecked(phoneNumberExist);
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield UserUnAuthorised();
        } else {
          yield UserOperationFailure();
        }
      }
    }

    if (event is UserUpdateStatus) {
      await userRepository.updateDriverStatus(event.status);
    }
  }
}
