import 'package:cached_network_image/cached_network_image.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/screens/award/lottery.dart';
import 'package:driverapp/utils/painter.dart';
import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../models/auth/auth.dart';
import '../../init/route.dart';
import '../../utils/colors.dart';
import 'package:http/http.dart' as http;

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  void initState() {
    _loadProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    return Drawer(
        child: Material(
            color: const Color.fromRGBO(240, 241, 241, 1),
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.5,
                  child: ClipPath(
                    clipper: WaveClipperD(),
                    child: Container(
                      height: 250,
                      color: themeProvider.getColor,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipperD(),
                  child: Container(
                    height: 220,
                    color: themeProvider.getColor,
                  ),
                ),
                Opacity(
                  opacity: 0.2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: height * 0.8,
                      color: themeProvider.getColor,
                      child: ClipPath(
                        clipper: WaveClipperBottomD(),
                        child: Container(
                          height: 60,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: height * 0.08, left: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey.shade300,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                            imageUrl: myPictureUrl,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) {
                                              return const Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.black,
                                              );
                                            }),
                                      )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 3.0, top: 10),
                                        child: Text(
                                          fullName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          phoneNumber,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0.0,
                              right: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.mode_edit_rounded,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        _editProfile();
                                      }),
                                ),
                              ),
                            ),
                          ],
                        )),
                    // SizedBox(
                    //   height: height * 0.02,
                    // ),
                    SizedBox(
                      height: height * 0.65,
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        height: MediaQuery.of(context).size.height - 300,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Wallet.routeName);
                              },
                              child: _menuItem(
                                  divider: true,
                                  context: context,
                                  icon: Icons.favorite,
                                  text: "Wallet"),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, HistoryPage.routeName);
                              },
                              child: _menuItem(
                                  divider: true,
                                  context: context,
                                  icon: Icons.history,
                                  text: "History"),
                            ),
                            //const Divider(color: Colors.grey),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Earning.routeName);
                              },
                              child: _menuItem(
                                  divider: true,
                                  context: context,
                                  icon: Icons.person,
                                  text: "Earning"),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.popAndPushNamed(
                                    context, LotteryScreen.routeName);
                              },
                              child: _menuItem(
                                  divider: true,
                                  context: context,
                                  icon: Icons.wallet_giftcard_outlined,
                                  text: "Award"),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.08,
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Card(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 5, bottom: 5, right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(LogOut());
                                    Navigator.pushReplacementNamed(
                                        context, SigninScreen.routeName);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: themeProvider.getColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Logout",
                                          style: TextStyle(
                                              color: themeProvider.getColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 10, bottom: 20, top: 10),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          themeProvider.changeTheme(3);
                                          setState(() {});
                                        },
                                        child: Container(
                                          //color: ColorProvider().primaryDeepOrange,
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: ColorProvider()
                                                .primaryDeepOrange,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          themeProvider.changeTheme(4);
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorProvider().primaryDeepBlue,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          themeProvider.changeTheme(6);
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorProvider().primaryDeepTeal,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ],
                )
              ],
            )));
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool divider,
  }) {
    const color = Colors.black;
    const hoverColor = Colors.white70;
    return ListTile(
      horizontalTitleGap: 0,
      trailing: IconButton(
          onPressed: () {}, icon: const Icon(Icons.navigate_next_rounded)),
      leading: Icon(icon, color: color),
      title: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      hoverColor: hoverColor,
    );
  }

  var fullName = "loading...";
  var phoneNumber = "loading...";

  _loadProfile() {
    var data = AuthDataProvider(httpClient: http.Client());
    data.getUserData().then((value) => {
          setState(() {
            fullName = '${value.name} ${value.lastName}';
            phoneNumber = value.phoneNumber;
          })
        });
  }
  _editProfile() {
    var data = AuthDataProvider(httpClient: http.Client());
    data.getUserData().then((value) => {
          setState(() {}),
          Navigator.pushNamed(context, EditProfile.routeName,
              arguments: EditProfileArgument(
                  auth: Auth(
                      phoneNumber: value.phoneNumber,
                      id: value.id,
                      name: value.name,
                      lastName: value.lastName,
                      email: value.email,
                      emergencyContact: value.emergencyContact,
                      profilePicture: value.profilePicture)))
        });
  }
}
