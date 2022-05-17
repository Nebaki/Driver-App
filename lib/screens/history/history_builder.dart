import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:driverapp/screens/history/snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import '../../dataprovider/database/database.dart';
import '../../models/credit/credit.dart';
import '../../models/trip/trip.dart';

import 'package:http/http.dart' as http;

class HistoryBuilder extends StatelessWidget {
  List<Trip> items;

  HistoryBuilder(this.items, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return items.isNotEmpty
        ? ListView.builder(
            addAutomaticKeepAlives: true,
            itemCount: items.length,
            padding: const EdgeInsets.all(0.0),
            itemBuilder: (context, item) {
              return _buildListItems(context, items[item], item);
            })
        : const Center(child: Text('No History'));
  }

  Widget _buildListItems(BuildContext context, Trip trip, int item) {
    if (trip.picture == null) {
      getImageBit(trip);
    } else {
      print("unit8: db-${trip.picture}");
      //trip.picture = trip.picture!.substring(0, trip.picture!.length - 3);
    }

    return Card(
        elevation: 4,
        child: Column(
          children: [
            trip.picture != null ? Image.memory(trip.picture!) : Container(),
            //getInstance(trip.origin,trip.destination),
            //trip.picture != null ? Image.file(ImageUtils().getImage("id-${trip.id}") : Container(),
            /*trip.picture != null
                ? FutureBuilder(
                    future: ImageUtils().getImage("id-${trip.id}"),
                    builder:
                        (BuildContext context, AsyncSnapshot<File> snapshot) {
                      return snapshot.data != null
                          ? Image.file(snapshot.data!,height: 200,)
                          : Container();
                    })
                : Container(),
            */
            ListTile(
              onTap: () async {},
              /*leading: Icon(
                credit.type == "Gift" ? Icons.wallet_giftcard : Icons.email,
                size: 40,
              ),*/
              title: Text(
                "From:  ${trip.pickUpAddress!}   To ${trip.dropOffAddress!}",
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              subtitle: Text('Date: ${trip.createdAt}'),
              trailing:
                  Text(trip.price!.split(",")[0]+".ETB", style: const TextStyle(color: Colors.red)),
            ),
          ],
        ));
  }

  void getImageBit(Trip trip) async {
    //downloadImage(trip);
    await ImageUtils.networkImageToBase64(imageUrl(trip)).then((value) => {
          //ImageUtils().saveImage(ImageUtils.base64ToUnit8list(value), "id-${trip.id}"),
          trip.picture = ImageUtils.base64ToUnit8list(value),
          print("unit8: net- ${imageUrl(trip)}"),
          updateDB(trip)
        });
  }

  Future<void> updateDB(Trip trip) async {
    await HistoryDB().updateTrip(trip).then((value) => {update()});
  }

  String imageUrl(Trip trip) {
    String googleAPiKey = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";
    return "https://maps.googleapis.com/maps/api/staticmap?"
        "size=600x250&"
        "zoom=15&"
        "maptype=roadmap&"
        "markers=color:green%7Clabel:S%7C${trip.pickUpLocation?.latitude},${trip.pickUpLocation?.longitude}&"
        "markers=color:red%7Clabel:E%7C${trip.dropOffLocation?.latitude},${trip.dropOffLocation?.longitude}&"
        "key=$googleAPiKey" /*"signature=YOUR_SIGNATURE"*/;
  }
}

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
  //comment out the next three lines to prevent the image from being saved
  //to the device to show that it's coming from the internet
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
            {
              print("img: dir exist"),
              writeImage(tempDir!, uint8list, name)
            }
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
