import 'package:driverapp/models/models.dart';
import 'package:driverapp/dataprovider/dataproviders.dart';

class EmergencyReportRepository {
  final EmergencyReportDataProvider dataProvider;

  EmergencyReportRepository({required this.dataProvider});

  Future createEmergencyReport(EmergencyReport emergencyReport) async {
    await dataProvider.createEmergencyReport(emergencyReport);
  }
}
