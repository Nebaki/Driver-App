import '../../screens/credit/telebirr_data.dart';
import '../../utils/constants.dart';
import '../../utils/session.dart';
import '../auth/auth.dart';

import 'package:http/http.dart' as http;
class RequestHeader{
  static const String baseURL = "https://safeway-api.herokuapp.com/api/";
  //static const String baseURL = "https://mobiletaxi-api.herokuapp.com/api/";
  static const String baseURLX = "https://mobiletaxi-api.herokuapp.com/api/";
  AuthDataProvider authDataProvider =
  AuthDataProvider(httpClient: http.Client());
  Future<Map<String,String>>? authorisedHeader() async => <String,String>{
    'Content-Type': 'application/json',
    'x-access-token': '${await authDataProvider.getToken()}'};

  Future<Map<String,String>>? defaultHeader() async => <String,String>{
    'Content-Type': 'application/json',
    'app-key': 'app-key'};
}

class RequestResult{
  Result requestResult(String code, String body){
    Session().logSession("response", "code: $code, body $body");
    if(code == "400"){
      return Result(code,false, body);
    }else{
      return Result(code,false, _prepareResult(code));
    }
  }
  String _prepareResult(code){
    switch(code){
      case Constants.anAuthorizedC:
        return Constants.anAuthorizedM;
      case Constants.accessForbiddenC:
        return Constants.accessForbiddenM;
      case Constants.notFoundC:
        return Constants.notFoundM;
      case Constants.serverErrorC:
        return Constants.serverErrorM;
      case Constants.requestTimeoutC:
        return Constants.requestTimeoutM;
      default:
        return Constants.unknownErrorM;
    }
  }
}