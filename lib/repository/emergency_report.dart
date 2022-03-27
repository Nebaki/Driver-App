import 'package:driverapp/models/models.dart';
import 'package:driverapp/dataprovider/dataproviders.dart';

class EmergencyReportRepository {
  final EmergencyReportDataProvider dataProvider;

  EmergencyReportRepository({required this.dataProvider});

  Future<void> createEmergencyReport(EmergencyReport emergencyReport) async {
    return await dataProvider.createEmergencyReport(emergencyReport);
  }
}
