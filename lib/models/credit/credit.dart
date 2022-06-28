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
  String? status;
  String? paymentMethod;
  DepositedBy? depositedBy;

  Credit(
      {this.id, this.title, this.message,
        this.type, this.amount, this.date,
        this.status,this.depositedBy,this.paymentMethod});

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      id: json["id"] ? null: "unknown",
      title: json["name"] ? null: "unknown",
      type: json["type"] ? null: "unknown",
      message: json["message"] ? null: "unknown",
      amount: json["amount"] ? null: "unknown",
      date: json["updated_at"] ? null: "unknown",
      status: json["status"] ? null: "unknown",
      paymentMethod: json["payment_method"] ? null: "unknown",
      depositedBy: json["deposited_by"],
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
      ' }';

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
        id: json["id"] ? null: "unknown",
        name: json["name"] ? null: "unknown",
        email: json["email"] ? null: "unknown",
        phone: json["phone"] ? null: "unknown");
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

  CreditStore({required this.trips});

  CreditStore.fromJson(List<dynamic> parsedJson) {
    trips = parsedJson.map((i) => Credit.fromStringObject(i)).toList();
  }

  CreditStore.getList() {
    trips;
  }

  String toJson() {
    String data = jsonEncode(trips?.map((i) => i.toString()).toList());
    return data;
  }
}
