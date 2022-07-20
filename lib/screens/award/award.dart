import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
// import 'package:driverapp/helper/localization.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:animated_background/animated_background.dart';

import '../../utils/constants/ui_strings.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';
import '../credit/toast_message.dart';

class AwardScreen extends StatefulWidget {
  static const routeName = '/award';

  AwardScreen({Key? key}) : super(key: key);

  @override
  State<AwardScreen> createState() => _AwardScreenState();
}

class _AwardScreenState extends State<AwardScreen> {
  final _appBar = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: CreditAppBar(
          key: _appBar, title: creditU, appBar: AppBar(), widgets: []),
      body: Stack(
        children: [
          /*AnimatedBackground(
            behaviour: RandomParticleBehaviour(),
            vsync: this,
            child: Text('Hello'),
          ),*/
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height,
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
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsUnAuthorised) {
                gotoSignIn(context);
              }
              if (state is SettingsLoadSuccess) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15, 200, 15, 0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                "Point",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "${state.settings.award.taxiPoint}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 34),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Divider(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
          /*const CustomeBackArrow(),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Award",
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
                const Divider(
                  thickness: 0.5,
                )
              ],
            ),
          )*/
        ],
      ),
    );
  }
}
