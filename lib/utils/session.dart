import 'dart:developer' as developer;

class Session{
  void logSuccess(String tag, String message){
    logSession("success-"+tag, message);
  }
  void logError(String tag, String message){
    logSession("error-"+tag, message);
  }
  void logSession(String tag, String message){
    developer.log(message,name: "session-"+tag,error: message,
        stackTrace: StackTrace.fromString(message));
    print('$tag: $message');
  }
}