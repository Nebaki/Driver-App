import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';

class OfflineMode extends StatelessWidget {
  bool isDriverOn = false;
  OfflineMode({Key? key}) : super(key: key);
  bool hasBalance = true;


  @override
  Widget build(BuildContext context) {
        var themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    if (isDriverOnline != null) {
      !isDriverOnline! ? Geofire.removeLocation(firebaseKey) : null;
    }
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: BlocBuilder<BalanceBloc, BalanceState>(
              builder: (context, state) {
                if (state is BalanceLoadSuccess) {
                  // return
                  if (state.balance > 0) {
                    return FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        isDriverOnline = true;
                        getLiveLocation();
                        context
                            .read<CurrentWidgetCubit>()
                            .changeWidget( OnlinMode());
                        // callback!(OnlinMode(callback, setDriverStatus));
                      },
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: themeProvider.getColor, width: 1.5),
                              borderRadius: BorderRadius.circular(100)),
                          child: const Text("Go")),
                    );
                  }
                }
                return FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: null,
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(100)),
                      child: const Text("Go")),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      color: Colors.grey,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 2)
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: const [
                 Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text(
                      "You're Offline",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.red,
                ),
                 OndriverStatus(isOnline: false),
                /////////////////////////////////////
              ],
            ),
          ),
        ],
      ),
    );
  }
}
