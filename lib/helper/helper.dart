import 'package:url_launcher/url_launcher.dart';

Future<void> _launchInBrowser(String url) async {
  if (!await launch(
    url,
    forceSafariVC: false,
    forceWebView: false,
    headers: <String, String>{'my_header_key': 'my_header_value'},
  )) {
    throw 'Could not launch $url';
  }
}

Future<void> _launchInWebViewOrVC(String url) async {
  if (!await launch(
    url,
    forceSafariVC: true,
    forceWebView: true,
    headers: <String, String>{'my_header_key': 'my_header_value'},
  )) {
    throw 'Could not launch $url';
  }
}

Future<void> _launchInWebViewWithJavaScript(String url) async {
  if (!await launch(
    url,
    forceSafariVC: true,
    forceWebView: true,
    enableJavaScript: true,
  )) {
    throw 'Could not launch $url';
  }
}

Future<void> _launchInWebViewWithDomStorage(String url) async {
  if (!await launch(
    url,
    forceSafariVC: true,
    forceWebView: true,
    enableDomStorage: true,
  )) {
    throw 'Could not launch $url';
  }
}

Future<void> _launchUniversalLinkIos(String url) async {
  final bool nativeAppLaunchSucceeded = await launch(
    url,
    forceSafariVC: false,
    universalLinksOnly: true,
  );
  if (!nativeAppLaunchSucceeded) {
    await launch(
      url,
      forceSafariVC: true,
    );
  }
}

// Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
//   if (snapshot.hasError) {
//     return Text('Error: ${snapshot.error}');
//   } else {
//     return const Text('');
//   }
// }

Future<void> makePhoneCall(String phoneNumber) async {
  // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
  // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
  // such as spaces in the input, which would cause `launch` to fail on some
  // platforms.
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launch(launchUri.toString());
}

Future<void> sendTextMessage(String phoneNumber) async {
  // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
  // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
  // such as spaces in the input, which would cause `launch` to fail on some
  // platforms.
  final Uri launchUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
  );
  await launch(launchUri.toString());
}
