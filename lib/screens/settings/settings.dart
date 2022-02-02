import 'package:flutter/material.dart';
import 'package:driverapp/screens/screens.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = "/settings";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            )),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        children: [
          _menuItem(
              context: context,
              icon: Icons.person,
              text: "My profile",
              routename: ProfileDetail.routeName),
          _menuItem(
              context: context,
              icon: Icons.document_scanner,
              text: "Personal Document",
              routename: ProfileDetail.routeName),
          _menuItem(
              context: context,
              icon: Icons.house,
              text: "Bank Details",
              routename: ProfileDetail.routeName),
          _menuItem(
              context: context,
              icon: Icons.lock,
              text: "Change Password",
              routename: ProfileDetail.routeName),
          SizedBox(
            height: 10,
          ),
          Text(
            "HELP",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          _menuItem(
              context: context,
              icon: Icons.person,
              text: "Term & Conditions",
              routename: ProfileDetail.routeName),
          _menuItem(
              context: context,
              icon: Icons.document_scanner,
              text: "Privacy Policies",
              routename: ProfileDetail.routeName),
          _menuItem(
              context: context,
              icon: Icons.house,
              text: "About",
              routename: ProfileDetail.routeName),
          _menuItem(
              context: context,
              icon: Icons.lock,
              text: "Contact Us",
              routename: ProfileDetail.routeName),
        ],
      ),
    );
  }

  Widget _menuItem(
      {required BuildContext context,
      required IconData icon,
      required String text,
      required String routename}) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(text,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
          hoverColor: hoverColor,
          onLongPress: () {},
          onTap: () {
            Navigator.pushNamed(context, routename);
          },
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
