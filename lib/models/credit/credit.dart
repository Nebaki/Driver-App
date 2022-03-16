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
  Credit(
      {this.id,
      this.title,
      this.message,
      this.type,
      this.amount,
      this.date});

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      id: json["id"],
      title: json["name"],
      type: json["type"],
      message: json["message"],
      amount: json["amount"],
      date: json["phone_number"],
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
      ' }';

   Credit.fromString(List<dynamic> parsedJson){
    parsedJson.map((i) => Credit.fromJson(i)).toList();
  }
}

class CreditStore{
  List<Credit>? trips;
  CreditStore({required this.trips});

  CreditStore.fromJson(List<dynamic> parsedJson){
    trips = parsedJson.map((i) => Credit.fromString(i)).toList();
  }
  CreditStore.getList(){
    trips;
  }

  String toJson() {
    String data = jsonEncode(trips?.map((i) => i.toString()).toList());
    return data;
  }
}