import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
// import 'package:driverapp/helper/localization.dart';
import 'package:driverapp/widgets/widgets.dart';

class AwardScreen extends StatelessWidget{
  static const routeName = '/award';

  const AwardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Stack(
        children: [
          BlocBuilder<SettingsBloc,SettingsState>(builder: (context, state) {
            if (state is SettingsLoadSuccess) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 100, 15, 0),
                child: Card(
                  
                          child: Padding(
                 padding: const EdgeInsets.all(5),
                 child: Container(
                   padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                        const Padding(
                         padding: EdgeInsets.only(top: 20),
                         child: Text(
                           "Point",
                           style: TextStyle(fontSize: 16, ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.symmetric(vertical: 10),
                         child: Text(
                           "${state.settings.award.taxiPoint}",
                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                         ),
                       ),
                       const Padding(
                         padding: EdgeInsets.only(top: 10),
                         child: Divider(),
                       ),
                       // Container(
                       //   height: 50,
                       //   child: Row(
                       //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                       //     children: [
                       //       Column(
                       //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       //         children: [
                       //           Text("15",),
                       //           Text(
                       //             "Trips",
                       //             style: TextStyle(color: Colors.grey),
                       //           )
                       //         ],
                       //       ),
                       //       const VerticalDivider(),
                       //       Column(
                       //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       //         children: [
                       //           Text("8:30",),
                       //           Text(
                       //             "Online hrs",
                       //             style: TextStyle(color: Colors.grey),
                       //           )
                       //         ],
                       //       ),
                       //       const VerticalDivider(),
                       //       Column(
                       //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       //         children: [
                       //           Text("22.48"),
                       //           Text(
                       //             "Cash Trips",
                       //             style: TextStyle(color: Colors.grey),
                       //           )
                       //         ],
                       //       ),
                       //     ],
                       //   ),
                       // ),
                     ],
                   ),
                 ),
                          ),
                        ),
              );
            }
            return Container();
          },),  const CustomeBackArrow(),
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
                  const Divider(thickness: 0.5,)
            ],
          ),
        )
        ],
      ),
    );
  }

}