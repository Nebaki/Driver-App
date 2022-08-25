import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/trip/trip.dart';

import 'package:http/http.dart' as http;
Future<void> downloadImage(Trip trip) async {
  String googleAPiKey = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";
  var url = "https://maps.googleapis.com/maps/api/staticmap?"
      "center=${trip.pickUpLocation?.latitude},${trip.pickUpLocation?.longitude}&"
      "size=600x250&"
      "zoom=10&"
      "maptype=roadmap&"
      "markers=color:green%7Clabel:S%7C${trip.pickUpLocation?.latitude},${trip.pickUpLocation?.longitude}&"
      "markers=color:red%7Clabel:E%7C${trip.dropOffLocation?.latitude},${trip.dropOffLocation?.longitude}&"
      "key=$googleAPiKey"; // <-- 1
  var response = await get(Uri.parse(url)); // <--2
  print("url-: $url");
  var documentDirectory = await getExternalStorageDirectory();
  var firstPath = documentDirectory!.path + "/images";
  var filePathAndName = documentDirectory.path + "/images/${trip.id}.jpg";
  await Directory(firstPath).create(recursive: true); // <-- 1
  File file2 = File(filePathAndName); // <-- 2
  file2.writeAsBytesSync(response.bodyBytes); // <-- 3
}

late Function update;

class ImageUtils {
  static MemoryImage base64ToImage(String base64String) {
    return MemoryImage(
      base64Decode(base64String),
    );
  }

  static Uint8List base64ToUnit8list(String base64String) {
    return base64.decode(base64String);
    //return base64Decode(base64String);
  }

  static String fileToBase64(File imgFile) {
    return base64Encode(imgFile.readAsBytesSync());
  }

  static Future networkImageToBase64(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return base64.encode(response.bodyBytes);
  }

  Future assetImageToBase64(String path) async {
    ByteData bytes = await rootBundle.load(path);
    return base64.encode(Uint8List.view(bytes.buffer));
  }

  Future<void> saveImage(Uint8List uint8list, String name) async {
    listDirs();
    final tempDir = await getExternalStorageDirectory();
    print("imgp: ${tempDir?.path}");
    Directory('${tempDir?.path}/historyIMG/').exists().then((value) => {
          if (value)
            {print("img: dir exist"), writeImage(tempDir!, uint8list, name)}
          else
            {print("img: dir not exist"), createDir(tempDir!, uint8list, name)}
        });
  }

  Future<File> getImage(String filename) async {
    final dir = await getExternalStorageDirectory();
    File f = File('${dir?.path}/historyIMG/$filename.png');
    f.exists().then((value) => {if (value) {} else {}});
    return f;
  }

  Future<void> writeImage(
      Directory directory, Uint8List uint8list, String filename) async {
    print("img-w: ${directory.path}");
    File file = await File('${directory.path}/historyIMG/$filename.png')
        .create(recursive: true);
    file.writeAsBytesSync(uint8list);
    await file.exists().then((value) => {print("img-w: $value")});
  }

  Future<void> createDir(
      Directory directory, Uint8List uint8list, String name) async {
    await Directory('${directory.path}/historyIMG/')
        .create(recursive: true)
        .then((value) => {
              print("img-c: ${value.path} created"),
              writeImage(directory, uint8list, name)
            });
  }

  void listDirs() {
    var systemTempDir = getExternalStorageDirectory();
    systemTempDir.then((value) => {
          value?.list(recursive: true, followLinks: false).listen((event) {
            print("img-d: ${value.path}");
          })
        });
  }
}
