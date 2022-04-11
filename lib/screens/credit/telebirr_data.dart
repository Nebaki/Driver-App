
class Result {
  final String code;
  final bool success;
  final String message;

  Result(this.code,this.success, this.message);
}

class TelePack {
  String message;
  int code;
  String? totalAmount;
  String? appId;
  String? receiverName;
  String? shortCode;
  String? subject;
  String? returnUrl;
  String? notifyUrl;
  String? timeoutExpress;
  String? appKey;
  String? publicKey;
  String? outTradeNumber;
  String? inAppPaymentUrl;

  TelePack(
      {required this.message,
        required this.code,
        this.totalAmount,
        this.appId,
        this.receiverName,
        this.shortCode,
        this.subject,
        this.returnUrl,
        this.notifyUrl,
        this.timeoutExpress,
        this.appKey,
        this.publicKey,
        this.inAppPaymentUrl,
        this.outTradeNumber});

  factory TelePack.fromJson(Map<String, dynamic> json,int code)
  => TelePack(
    message: json["message"],
    code: code,
    totalAmount: json["totalAmount"].toString(),
    appId: json["appId"],
    receiverName: json["receiverName"],
    shortCode: json["shortCode"].toString(),
    subject: json["subject"],
    returnUrl: json["returnUrl"],
    notifyUrl: json["notifyUrl"],
    timeoutExpress: json["timeoutExpress"],
    appKey: json["appKey"],
    publicKey: json["publicKey"],
    outTradeNumber: json["outTradeNumber"],
    inAppPaymentUrl: json["inAppPaymentUrl"],
  );


  @override
  String toString() => ' TelePack {'
      'code: $code,'
      'message: $message,'
      'totalAmount: $totalAmount,'
      'appId: $appId,'
      'receiverName: $receiverName,'
      'shortCode: $shortCode,'
      'subject: $subject,'
      'returnUrl: $returnUrl,'
      'notifyUrl: $notifyUrl,'
      'timeoutExpress: $timeoutExpress,'
      'appKey: $appKey,'
      'publicKey: $publicKey,'
      'outTradeNumber: $outTradeNumber,'
      'inAppPaymentUrl: $inAppPaymentUrl}';

  Map<String, dynamic> toJson() => {
    'code': '$code',
    'message': '$message',
    'totalAmount': '$totalAmount',
    'appId': '$appId',
    'receiverName': '$receiverName',
    'shortCode': '$shortCode',
    'subject': '$subject',
    'returnUrl': '$returnUrl',
    'notifyUrl': '$notifyUrl',
    'timeoutExpress': '$timeoutExpress',
    'appKey': '$appKey',
    'publicKey': '$publicKey',
    'outTradeNumber': '$outTradeNumber',
    'inAppPaymentUrl': '$inAppPaymentUrl'
  };
}
