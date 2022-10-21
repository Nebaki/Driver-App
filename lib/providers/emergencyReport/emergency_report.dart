import 'dart:convert';
import '../providers.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

class EmergencyReportDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/emergency-reports';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  EmergencyReportDataProvider({required this.httpClient});

  Future<void> createEmergencyReport(EmergencyReport emergencyReport) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-emergency-report'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
      body: json.encode({
        'location': [emergencyReport.location[0], emergencyReport.location[1]],
        'reported_by': "Driver",
        'trip_id': emergencyReport.tripId
      }),
    );
   
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return createEmergencyReport(emergencyReport);
      } else {
        throw Exception(response.statusCode);
      }
    }  else {
      throw Exception('Failed to create emergencyReport.');
    }
  }
}
