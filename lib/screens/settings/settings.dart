import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/init/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = "/settings";

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _textStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);


  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _loadPreTheme();
    super.initState();
  }

  _loadPreTheme() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.getColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
        String name;
        String phoneNumber;
        String? email;
        String? lastName;
        double? rating;
        double? balance;
        if (state is AuthDataLoadSuccess) {

          name = state.auth.name!;
          phoneNumber = state.auth.phoneNumber;
          email = state.auth.email;
          lastName = state.auth.lastName;
          balance = state.auth.balance;
          rating = state.auth.avgRate;
          return Stack(children: [
            Opacity(
              opacity: 0.5,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 250,
                  color: themeProvider.getColor,
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 160,
                color: themeProvider.getColor,
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 150,
                  color: themeProvider.getColor,
                  child: ClipPath(
                    clipper: WaveClipperBottom(),
                    child: Container(
                      height: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Profile(
                      id: state.auth.id,
                      emergencyContact: state.auth.emergencyContact,
                      imgUrl: state.auth.profilePicture!,
                      name: name,
                      email: email,
                      balance: balance,
                      phone: phoneNumber,
                      rating: rating,
                      lastName: lastName,
                      themeProvider: themeProvider,
                    ),
                  ),
                  Card(
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: Text(
                            "Preference",
                            style: _textStyle,
                          ),
                        ),
                        Divider(
                          color: themeProvider.getColor,
                          thickness: 1.5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 20, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(TextSpan(
                                  text: "Preferable Gender: ",
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
                              child: Text(
                                "Edit Preference",
                                style: TextStyle(
                                    color: themeProvider.getColor),
                              )),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: Text(
                            "Theme",
                            style: _textStyle,
                          ),
                        ),
                        Divider(
                          color: themeProvider.getColor,
                          thickness: 1.5,
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
                                       setState(() {
                                        
                                      });
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
                                      setState(() {
                                        
                                      });
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
                                       setState(() {
                                        
                                      });
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
                                       setState(() {
                                        
                                      });
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
                                       setState(() {
                                        
                                      });
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
                                       setState(() {
                                        
                                      });
                                    },
                                    child: Container(
                                      color: ColorProvider().primaryDeepTeal,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      themeProvider.changeTheme(7);
                                       setState(() {
                                        
                                      });
                                    },
                                    child: Container(
                                      color: ColorProvider().primaryDeepCheetah,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ]);
        }

        if (state is AuthDataLoading) {}
        return Container();
      }),
    );
  }

  var value = false;
}

class Profile extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String? lastName;
  final String? email;
  final String phone;
  final double? balance;
  final double? rating;
  final String? id;
  final String? emergencyContact;
  final ThemeProvider themeProvider;

  const Profile(
      { Key? key,
        required this.id,
      required this.emergencyContact,
      required this.imgUrl,
      required this.name,
      required this.email,
      required this.lastName,
      required this.phone,
      this.balance,
      this.rating,
      required this.themeProvider}):super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    List profileItems = [
      {'count': '$balance ETB', 'name': 'Balance'},
      {'count':  rating?.toStringAsFixed(1) , 'name': 'Rating'},
    ];
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 1.0,
      child: Container(
        height: deviceSize.height * 0.5,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: const BoxDecoration(
          //color: profile_info_background,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                ProfileImage(
                  height: 60.0,
                  width: 60.0,
                  imgUrl: imgUrl,
                  themeProvider: themeProvider,
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$name $lastName",
                        style: const TextStyle(
                          //color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 13.0,
                      ),
                      const Text(
                        'Driver',
                        style:  TextStyle(
                          //color: Colors.white70,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, EditProfile.routeName,
                          arguments: EditProfileArgument(
                              auth: Auth(
                                  phoneNumber: phone,
                                  id: id,
                                  name: name,
                                  lastName: lastName,
                                  email: email,
                                  emergencyContact: emergencyContact,
                                  profilePicture: imgUrl)));
                    },
                    icon: Icon(
                      Icons.border_color,
                      color: themeProvider.getColor,
                      size: 20.0,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ChangePassword.routeName);
                    },
                    icon: Icon(
                      Icons.password,
                      color: themeProvider.getColor,
                      size: 20.0,
                    )),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Divider(
              thickness: 1.5,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Balance:",style: TextStyle(fontSize: 10),),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.money,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            '$balance ETB',
                            style: const TextStyle(
                              //color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 1.5,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Phone:",style: TextStyle(fontSize: 10),),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            phone,
                            style: const TextStyle(
                              //color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              //color: themeProvider.getColor,
              thickness: 1.5,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                const Padding(
                  padding:  EdgeInsets.all(3.0),
                  child:  Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    email!,
                    style: const TextStyle(
                      //color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5.0,
            ),
            Divider(
              color: themeProvider.getColor,
              thickness: 1.5,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                for (var item in profileItems)
                  Column(
                    children: <Widget>[
                      Text(
                        item['count'],
                        style: const TextStyle(
                          //color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        item['name'],
                        style: const TextStyle(
                          //color: Colors.white70,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Row()
          ],
        ),

      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final double height, width;
  final Color color;
  final String imgUrl;
  final ThemeProvider themeProvider;
  const ProfileImage(
      {Key? key, this.height = 100.0,
      this.width = 100.0,
      this.color = Colors.white,
      required this.imgUrl, required this.themeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeProvider.getColor,
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.contain,
        ),
        border: Border.all(
          color: color,
          width: 3.0,
        ),
      ),
    );
  }
}