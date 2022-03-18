import 'package:flutter/material.dart';

class ShowToast{
  BuildContext context;
  String message;
  ShowToast(this.context,this.message);
  void show(){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}