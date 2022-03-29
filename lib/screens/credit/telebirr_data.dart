
class Result {
  final String code;
  final String message;

  Result(this.code, this.message);
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
  String? outTradeNo;

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
        this.outTradeNo});

  factory TelePack.fromJson(Map<String, dynamic> json)
  => TelePack(
    message: json["message"],
    code: json["code"],
    totalAmount: json["totalAmount"].toString(),
    appId: json["appId"],
    receiverName: json["receiverName"],
    shortCode: json["shortCode"],
    subject: json["subject"],
    returnUrl: json["returnUrl"],
    notifyUrl: json["notifyUrl"],
    timeoutExpress: json["timeoutExpress"],
    appKey: json["appKey"],
    publicKey: json["publicKey"],
    outTradeNo: json["outTradeNo"],
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
      'outTradeNo: $outTradeNo}';

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
    'outTradeNo': '$outTradeNo'
  };
}
