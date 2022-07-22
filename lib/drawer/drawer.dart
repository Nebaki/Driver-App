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

import '../dataprovider/auth/auth.dart';
import '../models/auth/auth.dart';
import '../route.dart';
import '../screens/award/awards.dart';
import '../utils/colors.dart';
import 'package:http/http.dart' as http;

import '../utils/session.dart';

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
                                // mainAxisAlignment: MainAxisAlignment.start,
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
                                                          //colorFilter:
                                                          //     const ColorFilter.mode(
                                                          //   Colors.red,
                                                          //   BlendMode.colorBurn,
                                                          // ),
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
                                          myName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          "0922877115",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
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
                                  decoration: new BoxDecoration(
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
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.pushReplacementNamed(
                            //         context, HomeScreen.routeName,
                            //         arguments: HomeScreenArgument(
                            //             isSelected: false, isOnline: false));
                            //   },
                            //   child: _menuItem(
                            //       divider: true,
                            //       context: context,
                            //       icon: Icons.home,
                            //       text: "Home"),
                            // ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Walet.routeName);
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
                            /*GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Summary.routeName);
                              },
                              child: _menuItem(
                                  divider: true,
                                  context: context,
                                  icon: Icons.person,
                                  text: "Summary"),
                            ),*/

                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.pushNamed(context, VehicleDocument.routeName);
                            //   },
                            //   child: _menuItem(
                            //       divider: true,
                            //       context: context,
                            //       icon: Icons.settings,
                            //       text: "Vehicle Document"),
                            // ),
                            // GestureDetector(
                            //   onTap: () {
                            //     print("sdfasdfa");
                            //     Navigator.pushNamed(context, PersonalDocument.routeName);
                            //   },
                            //   child: _menuItem(
                            //       divider: true,
                            //       context: context,
                            //       icon: Icons.settings,
                            //       text: "Personal Document"),
                            // ),

                            //const Divider(color: Colors.grey),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.pushNamed(context, SettingScreen.routeName);
                            //   },
                            //   child: _menuItem(
                            //       divider: true,
                            //       context: context,
                            //       icon: Icons.settings,
                            //       text: "Settings"),
                            // ),

                            //const Divider(color: Colors.grey),
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
                            //Divider(color: Colors.grey.shade500),

                            // GestureDetector(
                            //   onTap: () {
                            //     BlocProvider.of<AuthBloc>(context).add(LogOut());
                            //     Navigator.pushReplacementNamed(
                            //         context, SigninScreen.routeName);
                            //   },
                            //   child: _menuItem(
                            //       divider: false,
                            //       context: context,
                            //       icon: Icons.logout,
                            //       text: "Logout"),
                            // ),
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
/*
                            Card(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 5, bottom: 5, right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, SettingScreen.routeName);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.settings,
                                        color: themeProvider.getColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          "Settings",
                                          style: TextStyle(
                                              color: themeProvider.getColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
*/

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
                                          decoration: new BoxDecoration(
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
                                          //color: ColorProvider().primaryDeepBlue,
                                          height: 40,
                                          width: 40,
                                          decoration: new BoxDecoration(
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
                                          //color: ColorProvider().primaryDeepTeal,
                                          height: 40,
                                          width: 40,
                                          decoration: new BoxDecoration(
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
                              /*child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(0);
                                  },
                                  child: Container(
                                    color: ColorProvider().primaryDeepGreen,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(1);
                                  },
                                  child: Container(
                                    color: ColorProvider().primaryDeepRed,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(2);
                                  },
                                  child: Container(
                                    color: ColorProvider().primaryDeepPurple,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(3);
                                  },
                                  child: Container(
                                    color: ColorProvider().primaryDeepOrange,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(4);
                                  },
                                  child: Container(
                                    color: ColorProvider().primaryDeepBlue,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(5);
                                  },
                                  child: Container(
                                    color: ColorProvider().primaryDeepBlack,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(6);
                                  },
                                  child: Container(
                                    color: ColorProvider().primaryDeepTeal,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                            ],
                          )
                            */
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

// CustomPaint(
//         painter: DrawerBackGround(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//                 padding: const EdgeInsets.only(top: 40, left: 40),
//                 child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.grey.shade300,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: CachedNetworkImage(
//                               imageUrl: myPictureUrl,
//                               imageBuilder: (context, imageProvider) =>
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: imageProvider,
//                                         fit: BoxFit.cover,
//                                         //colorFilter:
//                                         //     const ColorFilter.mode(
//                                         //   Colors.red,
//                                         //   BlendMode.colorBurn,
//                                         // ),
//                                       ),
//                                     ),
//                                   ),
//                               placeholder: (context, url) =>
//                                   const CircularProgressIndicator(),
//                               errorWidget: (context, url, error) {
//                                 return const Icon(
//                                   Icons.person,
//                                   size: 50,
//                                   color: Colors.black,
//                                 );
//                               }),
//                         )),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     Text(
//                       myName,
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     )
//                   ],
//                 )
//                 //  BlocBuilder<AuthBloc, AuthState>(
//                 //   builder: (_, state) {
//                 //     if (state is AuthDataLoadSuccess) {
//                 //       return Column(
//                 //         // mainAxisAlignment: MainAxisAlignment.start,
//                 //         crossAxisAlignment: CrossAxisAlignment.start,
//                 //         children: [
//                 //           CircleAvatar(
//                 //               radius: 40,
//                 //               backgroundColor: Colors.grey.shade300,
//                 //               child: ClipRRect(
//                 //                 borderRadius: BorderRadius.circular(100),
//                 //                 child: CachedNetworkImage(
//                 //                     imageUrl: state.auth.profilePicture!,
//                 //                     imageBuilder: (context, imageProvider) =>
//                 //                         Container(
//                 //                           decoration: BoxDecoration(
//                 //                             image: DecorationImage(
//                 //                               image: imageProvider,
//                 //                               fit: BoxFit.cover,
//                 //                               //colorFilter:
//                 //                               //     const ColorFilter.mode(
//                 //                               //   Colors.red,
//                 //                               //   BlendMode.colorBurn,
//                 //                               // ),
//                 //                             ),
//                 //                           ),
//                 //                         ),
//                 //                     placeholder: (context, url) =>
//                 //                         const CircularProgressIndicator(),
//                 //                     errorWidget: (context, url, error) {
//                 //                       return Image.asset(
//                 //                           'assets/icons/avatar-icon.png');
//                 //                     }),
//                 //               )),
//                 //           const SizedBox(
//                 //             height: 15,
//                 //           ),
//                 //           Text(
//                 //             myName,
//                 //             style: Theme.of(context).textTheme.headlineSmall,
//                 //           )
//                 //         ],
//                 //       );
//                 //     }
//                 //     return Container();
//                 //   },
//                 // ),
//                 ),
//             const SizedBox(
//               height: 20,
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.only(top: 40),
//             //   child: Container(
//             //       padding: const EdgeInsets.symmetric(horizontal: 20),
//             //       height: 110,
//             //       decoration: const BoxDecoration(
//             //           color: Colors.white,
//             //           boxShadow: [
//             //             BoxShadow(
//             //                 color: Colors.black26,
//             //                 blurRadius: 7,
//             //                 spreadRadius: 3)
//             //           ]),
//             //       child: BlocBuilder<AuthBloc, AuthState>(
//             //         builder: (_, state) {
//             //           if (state is AuthDataLoadSuccess) {
//             //             return Row(
//             //               mainAxisAlignment: MainAxisAlignment.start,
//             //               crossAxisAlignment: CrossAxisAlignment.center,
//             //               children: [
//             //                 CircleAvatar(
//             //                     radius: 40,
//             //                     backgroundColor: Colors.grey.shade800,
//             //                     child: ClipRRect(
//             //                       borderRadius: BorderRadius.circular(100),
//             //                       child: CachedNetworkImage(
//             //                           imageUrl: state.auth.profilePicture!,
//             //                           imageBuilder: (context, imageProvider) =>
//             //                               Container(
//             //                                 decoration: BoxDecoration(
//             //                                   image: DecorationImage(
//             //                                     image: imageProvider,
//             //                                     fit: BoxFit.cover,
//             //                                     //colorFilter:
//             //                                     //     const ColorFilter.mode(
//             //                                     //   Colors.red,
//             //                                     //   BlendMode.colorBurn,
//             //                                     // ),
//             //                                   ),
//             //                                 ),
//             //                               ),
//             //                           placeholder: (context, url) =>
//             //                               const CircularProgressIndicator(),
//             //                           errorWidget: (context, url, error) {
//             //                             return const Icon(Icons.error);
//             //                           }),
//             //                     )),
//             //                 const SizedBox(
//             //                   width: 10,
//             //                 ),
//             //                 Expanded(
//             //                   child: Column(
//             //                     crossAxisAlignment: CrossAxisAlignment.start,
//             //                     mainAxisAlignment: MainAxisAlignment.center,
//             //                     children: [
//             //                       Text(
//             //                         state.auth.name!,
//             //                         style:
//             //                             Theme.of(context).textTheme.headline6,
//             //                       ),
//             //                       Text(state.auth.phoneNumber,
//             //                           style: Theme.of(context)
//             //                               .textTheme
//             //                               .subtitle1),
//             //                     ],
//             //                   ),
//             //                 )
//             //               ],
//             //             );
//             //           }
//             //           return const Text("Loading...");
//             //         },
//             //       )),
//             // ),
//             Container(
//               padding: const EdgeInsets.only(top: 20),
//               height: MediaQuery.of(context).size.height - 200,
//               child: ListView(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 children: [
//                   // GestureDetector(
//                   //   onTap: () {
//                   //     Navigator.pushReplacementNamed(
//                   //         context, HomeScreen.routeName,
//                   //         arguments: HomeScreenArgument(
//                   //             isSelected: false, isOnline: false));
//                   //   },
//                   //   child: _menuItem(
//                   //       divider: true,
//                   //       context: context,
//                   //       icon: Icons.home,
//                   //       text: "Home"),
//                   // ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, Walet.routeName);
//                     },
//                     child: _menuItem(
//                         divider: true,
//                         context: context,
//                         icon: Icons.favorite,
//                         text: "Wallet"),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, HistoryPage.routeName);
//                     },
//                     child: _menuItem(
//                         divider: true,
//                         context: context,
//                         icon: Icons.history,
//                         text: "History"),
//                   ),
//                   //const Divider(color: Colors.grey),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, Earning.routeName);
//                     },
//                     child: _menuItem(
//                         divider: true,
//                         context: context,
//                         icon: Icons.person,
//                         text: "Earning"),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, Summary.routeName);
//                     },
//                     child: _menuItem(
//                         divider: true,
//                         context: context,
//                         icon: Icons.person,
//                         text: "Summary"),
//                   ),

//                   // GestureDetector(
//                   //   onTap: () {
//                   //     Navigator.pushNamed(context, VehicleDocument.routeName);
//                   //   },
//                   //   child: _menuItem(
//                   //       divider: true,
//                   //       context: context,
//                   //       icon: Icons.settings,
//                   //       text: "Vehicle Document"),
//                   // ),
//                   // GestureDetector(
//                   //   onTap: () {
//                   //     print("sdfasdfa");
//                   //     Navigator.pushNamed(context, PersonalDocument.routeName);
//                   //   },
//                   //   child: _menuItem(
//                   //       divider: true,
//                   //       context: context,
//                   //       icon: Icons.settings,
//                   //       text: "Personal Document"),
//                   // ),

//                   //const Divider(color: Colors.grey),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, SettingScreen.routeName);
//                     },
//                     child: _menuItem(
//                         divider: true,
//                         context: context,
//                         icon: Icons.settings,
//                         text: "Settings"),
//                   ),

//                   //const Divider(color: Colors.grey),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.popAndPushNamed(context, AwardScreen.routeName);
//                     },
//                     child: _menuItem(
//                         divider: true,
//                         context: context,
//                         icon: Icons.wallet_giftcard_outlined,
//                         text: "Award"),
//                   ),

//                   const SizedBox(height: 20),
//                   //Divider(color: Colors.grey.shade500),

//                   GestureDetector(
//                     onTap: () {
//                       BlocProvider.of<AuthBloc>(context).add(LogOut());
//                       Navigator.pushReplacementNamed(
//                           context, SigninScreen.routeName);
//                     },
//                     child: _menuItem(
//                         divider: false,
//                         context: context,
//                         icon: Icons.logout,
//                         text: "Logout"),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//               child: Center(
//                 child: Text("Safe Way By Vintage Technologies",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w100, color: Colors.black45)),
//               ),
//             ),
//           ],
//         ),
//       ),
