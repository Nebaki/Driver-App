import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

final Connectivity _connectivity = Connectivity();

Future<bool> checkInternetConnection(context) async {
  ConnectivityResult result = await _connectivity.checkConnectivity();
  if (result == ConnectivityResult.none) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("No Internet Connection"),
      backgroundColor: Colors.red.shade900,
    ));
    return false;
  } else {
    return true;
  }
}
