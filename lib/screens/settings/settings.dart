import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = "/settings";

  final _textStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
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
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            )),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
        String name;
        String phoneNumber;
        print("Loadinggggggggggggggggggggggggg");
        if (state is AuthDataLoadSuccess) {
          name = state.auth.name!;
          phoneNumber = state.auth.phoneNumber;
          return ListView(
            padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
            children: [
              Card(
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 5),
                      child: Text(
                        "Profile",
                        style: _textStyle,
                      ),
                    ),
                    const Divider(
                      color: Colors.red,
                      thickness: 1.5,
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        radius: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: state.auth.profilePicture!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(100),
                        //   child: Container(
                        //     width: 300,
                        //     height: 300,
                        //     child: Image.network(
                        //       state.auth.profilePicture!,
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                    Center(child: Text(state.auth.name!)),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.auth.phoneNumber,
                            style: _textStyle,
                          ),
                          Text(
                            state.auth.email!,
                            style: _textStyle,
                          ),
                          Text(
                            state.auth.emergencyContact!,
                            style: _textStyle,
                          ),
                        ],
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, EditProfile.routeName,
                                arguments: EditProfileArgument(
                                    auth: Auth(
                                        phoneNumber: state.auth.phoneNumber,
                                        id: state.auth.id,
                                        name: state.auth.name,
                                        email: state.auth.email,
                                        emergencyContact:
                                            state.auth.emergencyContact,
                                        profilePicture:
                                            state.auth.profilePicture)));
                          },
                          child: const Text("Edit Profile")),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ChangePassword.routeName);
                          },
                          child: const Text("Change Password")),
                    ])
                  ],
                ),
              ),
              // Card(
              //   elevation: 3,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(top: 8, left: 5),
              //         child: Text(
              //           "Legal",
              //           style: _textStyle,
              //         ),
              //       ),
              //       const Divider(
              //         color: Colors.red,
              //         thickness: 1.5,
              //       ),
              //       Container(
              //         padding:
              //             const EdgeInsets.only(left: 10, bottom: 20, top: 10),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Contact Us",
              //               style: _textStyle,
              //             ),
              //             Text("Privacy Policy", style: _textStyle),
              //             Text("Terms & Conditions", style: _textStyle),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Card(
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 5),
                      child: Text(
                        "Preference",
                        style: _textStyle,
                      ),
                    ),
                    const Divider(
                      color: Colors.red,
                      thickness: 1.5,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 20, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(
                              text: "Driver Gender: ",
                              style: _textStyle,
                              children: [
                                TextSpan(
                                    text: state.auth.pref!["gender"],
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w300))
                              ])),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            //print(state.auth.);
                            Navigator.pushNamed(
                                context, PreferenceScreen.routeNAme,
                                arguments: PreferenceArgument(
                                    gender: state.auth.pref!['gender'],
                                    min_rate: double.parse(
                                      state.auth.pref!['min_rate'],
                                    ),
                                    carType: state.auth.pref!["car_type"]));
                            // Navigator.pushNamed(
                            //     context, PreferenceScreen.routeNAme);
                          },
                          child: const Text("Edit Preference")),
                    )
                  ],
                ),
              ),
              // Card(
              //   elevation: 3,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(top: 8, left: 5),
              //         child: Text(
              //           "App Info",
              //           style: _textStyle,
              //         ),
              //       ),
              //       const Divider(
              //         color: Colors.red,
              //         thickness: 1.5,
              //       ),
              //       Container(
              //         padding:
              //             const EdgeInsets.only(left: 10, bottom: 20, top: 10),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text.rich(TextSpan(
              //                 text: "Build Name: ",
              //                 style: _textStyle,
              //                 children: const [
              //                   TextSpan(
              //                       text: " SafeWay",
              //                       style: TextStyle(
              //                           fontStyle: FontStyle.italic,
              //                           fontWeight: FontWeight.w300))
              //                 ])),
              //             Text.rich(TextSpan(
              //                 text: "App Version: ",
              //                 style: _textStyle,
              //                 children: const [
              //                   TextSpan(
              //                       text: " 1.0",
              //                       style: TextStyle(
              //                           fontStyle: FontStyle.italic,
              //                           fontWeight: FontWeight.w300))
              //                 ])),
              //             Text.rich(TextSpan(
              //                 text: "Build Number: ",
              //                 style: _textStyle,
              //                 children: const [
              //                   TextSpan(
              //                       text: " 102034",
              //                       style: TextStyle(
              //                           fontStyle: FontStyle.italic,
              //                           fontWeight: FontWeight.w300))
              //                 ])),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Card(
              //   elevation: 3,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(top: 8, left: 5),
              //         child: Text(
              //           "About us",
              //           style: _textStyle,
              //         ),
              //       ),
              //       const Divider(
              //         color: Colors.red,
              //         thickness: 1.5,
              //       ),
              //       Container(
              //         padding:
              //             const EdgeInsets.only(left: 10, bottom: 20, top: 10),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text.rich(TextSpan(
              //                 text: "Owned by:\n  ",
              //                 style: _textStyle,
              //                 children: const [
              //                   TextSpan(
              //                       text: " Safeway Transport",
              //                       style: TextStyle(
              //                           fontStyle: FontStyle.italic,
              //                           fontWeight: FontWeight.w300))
              //                 ])),
              //             Text.rich(TextSpan(
              //                 text: "Developed by:\n  ",
              //                 style: _textStyle,
              //                 children: const [
              //                   TextSpan(
              //                       text: " Vintage Technologies",
              //                       style: TextStyle(
              //                           fontStyle: FontStyle.italic,
              //                           fontWeight: FontWeight.w300))
              //                 ])),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          );
        }

        if (state is AuthDataLoading) {}
        return Container();
      }),
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
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
          hoverColor: hoverColor,
          onLongPress: () {},
          onTap: () {
            Navigator.pushNamed(context, routename);
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
