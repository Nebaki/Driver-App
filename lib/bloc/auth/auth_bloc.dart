import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/repository/repositories.dart';
import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthDataLoading());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthLogin) {
      yield AuthSigningIn();
      try {
        await authRepository.loginUser(event.user);
        yield AuthLoginSuccess();
      } catch (_) {
        yield AuthOperationFailure();
      }
    }

    if (event is AuthDataLoad) {
      yield AuthDataLoading();
      try {
        final auth = await authRepository.getUserData();
        yield AuthDataLoadSuccess(auth);
      } catch (_) {
        print("ERRR $_");
        yield AuthOperationFailure();
      }
    }

    if (event is LogOut) {
      try {
        await authRepository.logOut();
        yield LogOutSuccess();
      } catch (_) {
        yield AuthOperationFailure();
      }
    }
  }
}
