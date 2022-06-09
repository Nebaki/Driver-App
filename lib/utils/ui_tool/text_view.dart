import 'package:flutter/cupertino.dart';

import '../properties/properties.dart';

class CreateText{
  String text;
  int size;
  int weight;
  CreateText({Key? key, required this.text,required this.size,required this.weight});
  Text build() {
    return Text(text,
        style: _textStyle(size, weight));
  }
  _textStyle(int size, int weight){
    return TextStyle(
        fontFamily: 'Sifonn',fontSize: _getFontSize(size), fontWeight: _getFontWeight(weight));
  }
  _getFontSize(int size){
    switch(size){
      case 1:
        return Props.bigFontSize;
      case 2:
        return Props.normalFontSize;
      case 3:
        return Props.smallFontSize;
    }
  }
  _getFontWeight(int size){
    switch(size){
      case 1:
        return FontWeight.normal;
      case 2:
        return FontWeight.bold;
    }
  }

}