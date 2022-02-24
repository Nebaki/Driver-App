import 'package:cached_network_image/cached_network_image.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 110,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26, blurRadius: 7, spreadRadius: 3)
                    ]),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (_, state) {
                    if (state is AuthDataLoadSuccess) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.auth.name!,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(state.auth.phoneNumber,
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                    return const Text("Loading...");
                  },
                )),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height - 170,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                GestureDetector(
                  onTap: () {
                    // print("YAyayyaay")
                    // _draweKEy.currentState!.close();
                  },
                  child: _menuItem(
                      divider: true,
                      context: context,
                      icon: Icons.home,
                      text: "Home"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Walet.routeName);
                  },
                  child: _menuItem(
                      divider: true,
                      context: context,
                      icon: Icons.favorite,
                      text: "Wallet"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
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

                // _menuItem(
                //     divider: true,
                //     context: context,
                //     icon: Icons.home,
                //     routename: HomeScreen.routeName,
                //     text: "Home"),
                // //const Divider(color: Colors.grey),
                // _menuItem(
                //     divider: true,
                //     context: context,
                //     icon: Icons.person,
                //     routename: ProfileDetail.routeName,
                //     text: "Profile"),
                // //const Divider(color: Colors.grey),
                // _menuItem(
                //     divider: true,
                //     context: context,
                //     icon: Icons.settings,
                //     routename: SettingScreen.routeName,
                //     text: "Settings"),
                // //const Divider(color: Colors.grey),
                // _menuItem(
                //     divider: true,
                //     context: context,
                //     icon: Icons.history,
                //     routename: HistoryPage.routeName,
                //     text: "History"),
                // _menuItem(
                //     divider: true,
                //     context: context,
                //     icon: Icons.favorite,
                //     routename: Walet.routeName,
                //     text: "Wallet"),
                // _menuItem(
                //     divider: true,
                //     context: context,
                //     icon: Icons.money,
                //     routename: Earning.routeName,
                //     text: "Earning"),
                // _menuItem(
                //     divider: true,
                //     context: context,
                //     icon: Icons.money,
                //     routename: Summary.routeName,
                //     text: "Summary"),

                // const SizedBox(height: 20),
                // //Divider(color: Colors.grey.shade500),
                // _menuItem(
                //     divider: false,
                //     context: context,
                //     icon: Icons.logout,
                //     routename: VehicleDocument.routeName,
                //     text: "Vehicle Document"),
                // _menuItem(
                //     divider: false,
                //     context: context,
                //     icon: Icons.logout,
                //     routename: PersonalDocument.routeName,
                //     text: "Personal Document"),
                // _menuItem(
                //     divider: false,
                //     context: context,
                //     icon: Icons.logout,
                //     routename: SigninScreen.routeName,
                //     text: "Logout"),
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

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool divider,
  }) {
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
