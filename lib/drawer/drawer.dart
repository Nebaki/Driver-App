import 'package:flutter/material.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 110,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 7, spreadRadius: 3)
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade800,
                    // backgroundImage:
                    //     AssetImage("assets/images/restaurant4.jpg"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Eyob Tilahun",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text("Addis Ababa",
                          style: Theme.of(context).textTheme.subtitle1),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height - 170,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _menuItem(
                    divider: true,
                    context: context,
                    icon: Icons.home,
                    routename: "HomeScreen.routeName",
                    text: "Home"),
                //const Divider(color: Colors.grey),
                _menuItem(
                    divider: true,
                    context: context,
                    icon: Icons.person,
                    routename: "ProfileDetail.routeName",
                    text: "Profile"),
                //const Divider(color: Colors.grey),
                _menuItem(
                    divider: true,
                    context: context,
                    icon: Icons.settings,
                    routename: "SettingScreen.routeName",
                    text: "Settings"),
                //const Divider(color: Colors.grey),
                _menuItem(
                    divider: true,
                    context: context,
                    icon: Icons.history,
                    routename: "HistoryPage.routeName",
                    text: "History"),
                _menuItem(
                    divider: true,
                    context: context,
                    icon: Icons.favorite,
                    routename: Walet.routeName,
                    text: "Wallet"),
                _menuItem(
                    divider: true,
                    context: context,
                    icon: Icons.money,
                    routename: Earning.routeName,
                    text: "Earning"),
                _menuItem(
                    divider: true,
                    context: context,
                    icon: Icons.money,
                    routename: Summary.routeName,
                    text: "Summary"),

                const SizedBox(height: 20),
                //Divider(color: Colors.grey.shade500),

                _menuItem(
                    divider: false,
                    context: context,
                    icon: Icons.logout,
                    routename: "ProfileDetail.routeName",
                    text: "Logout"),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
            child: Center(
              child: Text("Safe Way By Vintage Technologies",
                  style: TextStyle(
                      fontWeight: FontWeight.w100, color: Colors.black45)),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _menuItem(
      {required BuildContext context,
      required IconData icon,
      required String text,
      required bool divider,
      required String routename}) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          trailing: IconButton(
              onPressed: () {}, icon: Icon(Icons.navigate_next_rounded)),
          leading: Icon(icon, color: color.shade700),
          title: Text(text, style: Theme.of(context).textTheme.bodyText2),
          hoverColor: hoverColor,
          onLongPress: () {},
          onTap: () {
            Navigator.pushNamed(context, routename);
          },
        ),
        divider
            ? Padding(
                padding: const EdgeInsets.only(left: 65, right: 20),
                child: Divider(color: Colors.grey.shade200),
              )
            : Container(),
      ],
    );
  }
}
