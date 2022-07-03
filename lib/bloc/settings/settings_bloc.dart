// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:driverapp/repository/repositories.dart';
import 'package:driverapp/models/models.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  SettingsBloc({required this.settingsRepository}) : super(SettingsLoading());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SettingsStarted) {
      yield (SettingsLoading());
      try {
        final items = await settingsRepository.getSettings();
        yield (SettingsLoadSuccess(settings: items));
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield SettingsUnAuthorised();
        } else {
          yield (SettingsOperationFailure());
        }
      }
    }
  }
}
