import 'package:cached_network_image/cached_network_image.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/drawer/custome_paint.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../utils/painter.dart';
import '../utils/theme/ThemeProvider.dart';

class NavDrawer extends StatelessWidget {
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
              Padding(
                  padding: EdgeInsets.only(top: height * 0.08, left: 40),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                                imageUrl: myPictureUrl,
                                imageBuilder: (context, imageProvider) =>
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
                                  return Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.black,
                                  );
                                }),
                          )),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Text(
                        myName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                    ],
                  )
                //  BlocBuilder<AuthBloc, AuthState>(
                //   builder: (_, state) {
                //     if (state is AuthDataLoadSuccess) {
                //       return Column(
                //         // mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           CircleAvatar(
                //               radius: 40,
                //               backgroundColor: Colors.grey.shade300,
                //               child: ClipRRect(
                //                 borderRadius: BorderRadius.circular(100),
                //                 child: CachedNetworkImage(
                //                     imageUrl: state.auth.profilePicture!,
                //                     imageBuilder: (context, imageProvider) =>
                //                         Container(
                //                           decoration: BoxDecoration(
                //                             image: DecorationImage(
                //                               image: imageProvider,
                //                               fit: BoxFit.cover,
                //                               //colorFilter:
                //                               //     const ColorFilter.mode(
                //                               //   Colors.red,
                //                               //   BlendMode.colorBurn,
                //                               // ),
                //                             ),
                //                           ),
                //                         ),
                //                     placeholder: (context, url) =>
                //                         const CircularProgressIndicator(),
                //                     errorWidget: (context, url, error) {
                //                       return Image.asset(
                //                           'assets/icons/avatar-icon.png');
                //                     }),
                //               )),
                //           const SizedBox(
                //             height: 15,
                //           ),
                //           Text(
                //             myName,
                //             style: Theme.of(context).textTheme.headlineSmall,
                //           )
                //         ],
                //       );
                //     }
                //     return Container();
                //   },
                // ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 40),
              //   child: Container(
              //       padding: const EdgeInsets.symmetric(horizontal: 20),
              //       height: 110,
              //       decoration: const BoxDecoration(
              //           color: Colors.white,
              //           boxShadow: [
              //             BoxShadow(
              //                 color: Colors.black26,
              //                 blurRadius: 7,
              //                 spreadRadius: 3)
              //           ]),
              //       child: BlocBuilder<AuthBloc, AuthState>(
              //         builder: (_, state) {
              //           if (state is AuthDataLoadSuccess) {
              //             return Row(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 CircleAvatar(
              //                     radius: 40,
              //                     backgroundColor: Colors.grey.shade800,
              //                     child: ClipRRect(
              //                       borderRadius: BorderRadius.circular(100),
              //                       child: CachedNetworkImage(
              //                           imageUrl: state.auth.profilePicture!,
              //                           imageBuilder: (context, imageProvider) =>
              //                               Container(
              //                                 decoration: BoxDecoration(
              //                                   image: DecorationImage(
              //                                     image: imageProvider,
              //                                     fit: BoxFit.cover,
              //                                     //colorFilter:
              //                                     //     const ColorFilter.mode(
              //                                     //   Colors.red,
              //                                     //   BlendMode.colorBurn,
              //                                     // ),
              //                                   ),
              //                                 ),
              //                               ),
              //                           placeholder: (context, url) =>
              //                               const CircularProgressIndicator(),
              //                           errorWidget: (context, url, error) {
              //                             return const Icon(Icons.error);
              //                           }),
              //                     )),
              //                 const SizedBox(
              //                   width: 10,
              //                 ),
              //                 Expanded(
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Text(
              //                         state.auth.name!,
              //                         style:
              //                             Theme.of(context).textTheme.headline6,
              //                       ),
              //                       Text(state.auth.phoneNumber,
              //                           style: Theme.of(context)
              //                               .textTheme
              //                               .subtitle1),
              //                     ],
              //                   ),
              //                 )
              //               ],
              //             );
              //           }
              //           return const Text("Loading...");
              //         },
              //       )),
              // ),
              Container(
                padding: EdgeInsets.only(top: height * 0.02),
                height: height * 0.65,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.routeName,
                            arguments: HomeScreenArgument(
                                isSelected: false, isOnline: false));
                      },
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.home,
                          text: "Home"),
                    ),
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
                        Navigator.pushNamed(context, HistoryPage.routeName);
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
                        Navigator.pushNamed(context, Summary.routeName);
                      },
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.person,
                          text: "Summary"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.08,
                child:
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0,top: 5,bottom: 5,right: 10),
                          child: GestureDetector(
                            onTap: () {
                              BlocProvider.of<AuthBloc>(context).add(LogOut());
                              Navigator.pushReplacementNamed(
                                  context, SigninScreen.routeName);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.logout,color: themeProvider.getColor,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Logout",style: TextStyle(color: themeProvider.getColor),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0,top: 5,bottom: 5,right: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, SettingScreen.routeName);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.settings,color: themeProvider.getColor,),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text("Settings",style: TextStyle(color: themeProvider.getColor),),
                                ),
                              ],
                            ),

                          ),
                        ),
                      ),
                    ]
                ),
              ),
              /*const SizedBox(
              height: 15,
              child: Center(
                child: Text("Safe Way By Vintage Technologies",
                    style: TextStyle(
                        fontWeight: FontWeight.w100, color: Colors.black45)),
              ),
            ),*/
            ],
          ),
        ],
      )
    /*  child: CustomPaint(
        painter: DrawerBackGround(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: height * 0.08, left: 40),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                              imageUrl: myPictureUrl,
                              imageBuilder: (context, imageProvider) =>
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
                                return Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.black,
                                );
                              }),
                        )),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      myName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ],
                )
                //  BlocBuilder<AuthBloc, AuthState>(
                //   builder: (_, state) {
                //     if (state is AuthDataLoadSuccess) {
                //       return Column(
                //         // mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           CircleAvatar(
                //               radius: 40,
                //               backgroundColor: Colors.grey.shade300,
                //               child: ClipRRect(
                //                 borderRadius: BorderRadius.circular(100),
                //                 child: CachedNetworkImage(
                //                     imageUrl: state.auth.profilePicture!,
                //                     imageBuilder: (context, imageProvider) =>
                //                         Container(
                //                           decoration: BoxDecoration(
                //                             image: DecorationImage(
                //                               image: imageProvider,
                //                               fit: BoxFit.cover,
                //                               //colorFilter:
                //                               //     const ColorFilter.mode(
                //                               //   Colors.red,
                //                               //   BlendMode.colorBurn,
                //                               // ),
                //                             ),
                //                           ),
                //                         ),
                //                     placeholder: (context, url) =>
                //                         const CircularProgressIndicator(),
                //                     errorWidget: (context, url, error) {
                //                       return Image.asset(
                //                           'assets/icons/avatar-icon.png');
                //                     }),
                //               )),
                //           const SizedBox(
                //             height: 15,
                //           ),
                //           Text(
                //             myName,
                //             style: Theme.of(context).textTheme.headlineSmall,
                //           )
                //         ],
                //       );
                //     }
                //     return Container();
                //   },
                // ),
                ),
            SizedBox(
              height: height * 0.02,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 40),
            //   child: Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 20),
            //       height: 110,
            //       decoration: const BoxDecoration(
            //           color: Colors.white,
            //           boxShadow: [
            //             BoxShadow(
            //                 color: Colors.black26,
            //                 blurRadius: 7,
            //                 spreadRadius: 3)
            //           ]),
            //       child: BlocBuilder<AuthBloc, AuthState>(
            //         builder: (_, state) {
            //           if (state is AuthDataLoadSuccess) {
            //             return Row(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 CircleAvatar(
            //                     radius: 40,
            //                     backgroundColor: Colors.grey.shade800,
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(100),
            //                       child: CachedNetworkImage(
            //                           imageUrl: state.auth.profilePicture!,
            //                           imageBuilder: (context, imageProvider) =>
            //                               Container(
            //                                 decoration: BoxDecoration(
            //                                   image: DecorationImage(
            //                                     image: imageProvider,
            //                                     fit: BoxFit.cover,
            //                                     //colorFilter:
            //                                     //     const ColorFilter.mode(
            //                                     //   Colors.red,
            //                                     //   BlendMode.colorBurn,
            //                                     // ),
            //                                   ),
            //                                 ),
            //                               ),
            //                           placeholder: (context, url) =>
            //                               const CircularProgressIndicator(),
            //                           errorWidget: (context, url, error) {
            //                             return const Icon(Icons.error);
            //                           }),
            //                     )),
            //                 const SizedBox(
            //                   width: 10,
            //                 ),
            //                 Expanded(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Text(
            //                         state.auth.name!,
            //                         style:
            //                             Theme.of(context).textTheme.headline6,
            //                       ),
            //                       Text(state.auth.phoneNumber,
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .subtitle1),
            //                     ],
            //                   ),
            //                 )
            //               ],
            //             );
            //           }
            //           return const Text("Loading...");
            //         },
            //       )),
            // ),
            Container(
              padding: EdgeInsets.only(top: height * 0.02),
              height: height * 0.65,
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
                      Navigator.pushNamed(context, HistoryPage.routeName);
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
                      Navigator.pushNamed(context, Summary.routeName);
                    },
                    child: _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.person,
                        text: "Summary"),
                  ),

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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SettingScreen.routeName);
                    },
                    child: _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.settings,
                        text: "Settings"),
                  ),

                  //const Divider(color: Colors.grey),
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, AwardScreen.routeName);
                    },
                    child: _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.wallet_giftcard_outlined,
                        text: "Award"),
                  ),

                  SizedBox(height: height * 0.02),
                  //Divider(color: Colors.grey.shade500),

                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AuthBloc>(context).add(LogOut());
                      Navigator.pushReplacementNamed(
                          context, SigninScreen.routeName);
                    },
                    child: _menuItem(
                        divider: false,
                        context: context,
                        icon: Icons.logout,
                        text: "Logout"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.08,
              child:
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0,top: 5,bottom: 5,right: 10),
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<AuthBloc>(context).add(LogOut());
                            Navigator.pushReplacementNamed(
                                context, SigninScreen.routeName);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Logout",style: TextStyle(color: Colors.white),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0,top: 5,bottom: 5,right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SettingScreen.routeName);
                          },
                          child: Row(
                              children: [
                                Icon(Icons.settings,color: themeProvider.getColor,),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text("Settings",style: TextStyle(color: themeProvider.getColor),),
                                ),
                              ],
                            ),

                        ),
                      ),
                    ),
                  ]
              ),
            ),
            *//*const SizedBox(
              height: 15,
              child: Center(
                child: Text("Safe Way By Vintage Technologies",
                    style: TextStyle(
                        fontWeight: FontWeight.w100, color: Colors.black45)),
              ),
            ),*//*
          ],
        ),
      ),
    */
    ));
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
      trailing:
          IconButton(onPressed: () {}, icon: Icon(Icons.navigate_next_rounded)),
      leading: Icon(icon, color: color),
      title: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      hoverColor: hoverColor,
    );
  }
}
