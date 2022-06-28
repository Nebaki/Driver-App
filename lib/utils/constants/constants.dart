
class Constants{
  int code = 0;
  static const int requestSuccess = 200;
  static const int anAuthorizedC = 401;
  static const String anAuthorizedM = "Unauthorized Access";
  static const int accessForbiddenC = 403;
  static const String accessForbiddenM = "Access forbidden";
  static const int notFoundC = 404;
  static const String notFoundM = "Not Found";
  static const int methodExceptionC = 405;
  static const String methodExceptionM = "Method Not Allowed";
  static const int serverErrorC = 500;
  static const String serverErrorM = "Server Error";
  static const int unknownErrorC = 00;
  static const String unknownErrorM = "Server Error";
  static const int requestTimeoutC = 408;
  static const String requestTimeoutM = "Unable To Confirm Payment: Timeout";
}