import '../auth/auth.dart';

import 'package:http/http.dart' as http;
class RequestHeader{
  static const String baseURL = "https://safeway-api.herokuapp.com/api/";
  AuthDataProvider authDataProvider =
  AuthDataProvider(httpClient: http.Client());
  Future<Map<String,String>>? authorisedHeader() async => <String,String>{
    'Content-Type': 'application/json',
    'x-access-token': '${await authDataProvider.getToken()}'};

  Future<Map<String,String>>? defaultHeader() async => <String,String>{
    'Content-Type': 'application/json',
    'x-access-token': '${await authDataProvider.getToken()}'};
}