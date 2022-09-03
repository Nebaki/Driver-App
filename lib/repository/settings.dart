import 'package:driverapp/providers/providers.dart';
import 'package:driverapp/models/models.dart';

class SettingsRepository {
  final SettingsDataProvider settingsDataProvider;
  const SettingsRepository({required this.settingsDataProvider});

  Future<Settings> getSettings (){
    return settingsDataProvider.getSettings();
  }
}