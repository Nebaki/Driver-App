part of 'settings_bloc.dart';
abstract class SettingsState extends Equatable {
  const SettingsState();
  
 
}
class SettingsLoading extends SettingsState {
  @override
  List<Object?> get props => [];
}

class SettingsLoadSuccess extends SettingsState {
  final Settings settings;
  const SettingsLoadSuccess({required this.settings});
    @override
  List<Object?> get props => [];
}

class SettingsOperationFailure extends SettingsState {
    @override
  List<Object?> get props => [];
}

class SettingsUnAuthorised extends SettingsState {
    @override
  List<Object?> get props => [];
}