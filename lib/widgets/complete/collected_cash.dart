import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/init/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/credit/toast_message.dart';

class CollectedCash extends StatefulWidget {
  static const routeName = "/collectedcash";
  final CollectedCashScreenArgument args;

  const CollectedCash({Key? key, required this.args}) : super(key: key);

  @override
  State<CollectedCash> createState() => _CollectedCashState();
}

class _CollectedCashState extends State<CollectedCash> {
  @override
  void dispose() {
    super.dispose();
  }
  final _appBar = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F9),
        appBar: CreditAppBar(
            key: _appBar, title: "Order Completed", appBar: AppBar(), widgets: []),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "${widget.args.price.toStringAsFixed(2)} ETB",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 34),
                      ),
                    ),
                    Text(
                      "Collected cash from ${widget.args.name}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(),
                    ),
                  ],
                ),
              ),
              BlocBuilder<BalanceBloc, BalanceState>(builder: (context, state) {
                if (state is BalanceLoadSuccess) {
                  return Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            if (state.balance > 0) {
                              BlocProvider.of<DirectionBloc>(context).add(
                                  const DirectionChangeToInitialState(
                                      isBalanceSufficient: true,isFromOnlineMode: true));
                            } else {
                              BlocProvider.of<DirectionBloc>(context).add(
                                  const DirectionChangeToInitialState(
                                      isBalanceSufficient: false,isFromOnlineMode: true));
                            }

                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Done",
                            style: TextStyle(color: Colors.white),
                          )));
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
