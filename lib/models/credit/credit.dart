import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Credit {
  String? id;
  String? title;
  String? message;
  String? amount;
  String? type;
  String? date;
  String? status;//-1 failed, 0 pending, 1 success
  String? paymentMethod;
  DepositedBy? depositedBy;

  Credit(
      {this.id, this.title, this.message,
        this.type, this.amount, this.date,
        this.status,this.depositedBy,this.paymentMethod});

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      id: json["id"] ?? "unknown",
      title: json["name"] ?? "unknown",
      type: json["type"] ?? "unknown",
      message: json["reason"] ?? "unknown",
      amount: json["amount"] ?? "unknown",
      date: json["updated_at"] ?? "unknown",
      status: json["status"] ?? "unknown",
      paymentMethod: json["payment_method"] ?? "unknown",
      depositedBy: DepositedBy.fromJson(json["deposited_by"])
        /*(
        id: json["deposited_by"]["id"],
        name: json["deposited_by"]["name"],
        email: json["deposited_by"]["email"],
        phone: json["deposited_by"]["phone"]
      ),*/
    );
  }

  @override
  String toString() => 'credit {'
      'title: $title,'
      'message: $message,'
      'amount: $amount,'
      'type: $type,'
      'date: $date,'
      'id: $id,'
      'status: $status,'
      'paymentMethod: $paymentMethod,'
      'depositedBy: ${depositedBy.toString()},'
      '}';

  Credit.fromStringObject(List<dynamic> parsedJson) {
    parsedJson.map((i) => Credit.fromJson(i)).toList();
  }
}

class DepositedBy {
  String? id;
  String? name;
  String? email;
  String? phone;

  DepositedBy({this.id, this.name, this.email, this.phone});

  factory DepositedBy.fromJson(Map<String, dynamic> json) {
    return DepositedBy(
        id: json["id"] ?? "unknown",
        name: json["name"] ?? "unknown",
        email: json["email"] ?? "unknown",
        phone: json["phone"] ?? "unknown");
  }

  @override
  String toString() => 'credit {'
      'id: $id,'
      'name: $name,'
      'email: $email,'
      'phone: $phone,'
      ' }';

  DepositedBy.fromStringObject(List<dynamic> parsedJson) {
    parsedJson.map((i) => Credit.fromJson(i)).toList();
  }
}

class CreditStore {
  List<Credit>? trips;
  int total;
  CreditStore({required this.trips,required this.total});

  CreditStore.fromJson(List<dynamic> parsedJson,this.total) {
    trips = parsedJson.map((i) => Credit.fromStringObject(i)).toList();
  }

  String toJson() {
    String data = jsonEncode(trips?.map((i) => i.toString()).toList());
    return data;
  }
}
