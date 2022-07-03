import 'package:flutter_bloc/flutter_bloc.dart';

class DisableButtonCubit extends Cubit<bool> {
  DisableButtonCubit() : super(false);
  void disableButton() => emit(true);
  void enableButton() => emit(false);
}
