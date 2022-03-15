import 'package:cached_network_image/cached_network_image.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/drawer/custome_paint.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
      color: const Color.fromRGBO(240, 241, 241, 1),
      child: CustomPaint(
        painter: DrawerBackGround(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 40),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (_, state) {
                  if (state is AuthDataLoadSuccess) {
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade800,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                  imageUrl: state.auth.profilePicture!,
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
                                    return const Icon(Icons.error);
                                  }),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          state.auth.name!,
                          style: Theme.of(context).textTheme.headlineSmall,
                        )
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(
              height: 20,
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
              padding: EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height - 200,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  GestureDetector(
                    onTap: () {},
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

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, VehicleDocument.routeName);
                    },
                    child: _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.settings,
                        text: "Vehicle Document"),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("sdfasdfa");
                      Navigator.pushNamed(context, PersonalDocument.routeName);
                    },
                    child: _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.settings,
                        text: "Personal Document"),
                  ),

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

                  const SizedBox(height: 20),
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
      ),
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
