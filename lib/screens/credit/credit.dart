import 'package:driverapp/models/models.dart';
import 'package:driverapp/init/route.dart';
import 'package:driverapp/screens/credit/credit_form.dart';
import 'package:driverapp/screens/credit/credit_request.dart';
import 'package:driverapp/screens/credit/transfer_form.dart';
import 'package:driverapp/utils/constants/net_status.dart';
import 'package:driverapp/utils/constants/ui_strings.dart';
import 'package:driverapp/utils/ui_tool/tools.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../bloc/balance/balance.dart';
import '../../providers/providers.dart';
import '../../helper/helper.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';
import '../home/dialogs/insufficent_balance.dart';
import 'toast_message.dart';

class Wallet extends StatefulWidget {
  static const routeName = "/credit";

  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => WalletState();
}

class WalletState extends State<Wallet> {
  final _appBar = GlobalKey<FormState>();
  final _inkwelTextStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  late ThemeProvider themeProvider;

  @override
  void initState() {
    _isBalanceLoading = true;
    _isMessageLoading = true;
    reloadBalance();
    prepareRequest(context, 0, _limit);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _controller = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  bool hasBalance = false;
  _loadBalance(){
    return BlocConsumer<BalanceBloc,
        BalanceState>(
        builder: (context, state) {
          context.read<BalanceBloc>().add(BCLoad());
          return Container();
        },
        listener: (context, state) {
          if (state
          is BCLoadUnAuthorised) {
            gotoSignIn(context);
          }
          if (state
          is BCOperationFailure) {

          }
          if (state is BCLoadSuccess) {
            balance = state.balanceCredit.split("|")[0];
            credit = state.balanceCredit.split("|")[1];
          }
        });
  }
  @override
  Widget build(BuildContext context) {
    // When nothing else to load
    if (_hasNextPage == false) {
      //ShowSnack(context:context, message:fetchedAllI).show();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CreditAppBar(
          key: _appBar, title: creditU, appBar: AppBar(), widgets: []),
      body: Stack(
        children: [
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
          //_loadBalance(),
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 5.0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              creditBalanceU,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          /*Flexible(child:
                              BlocBuilder<BalanceBloc, BalanceState>(
                                  builder: (context, state) {
                                    if(state is BalanceLoading){

                                    }
                                    if(state is BalanceLoadSuccess){

                                    }
                                    if(state is BalanceOperationFailure){

                                    }
                            return Text("100");
                          })),
                          */
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _isBalanceLoading
                                ? SpinKitThreeBounce(
                                    color: themeProvider.getColor,
                                    size: 30,
                                  )
                                : Text(
                                    formatCurrency(balance),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 34),
                                  ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Divider(),
                          ),
                          Card(
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: themeProvider.getColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                //color: Colors.deepOrange,
                                height: 40,
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Center(
                                        child: InkWell(
                                      child: Text(
                                        transferU,
                                        style: _inkwelTextStyle,
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, TransferMoney.routeName,
                                            arguments: TransferCreditArgument(
                                                balance: balance));
                                      },
                                    )),
                                    const VerticalDivider(
                                      color: Colors.white,
                                      thickness: 3,
                                    ),
                                    Center(
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  TeleBirrData.routeName);
                                              /*showDialog(
                                                  context: context,
                                                  builder: (_) => PaymentBox(),
                                                  barrierDismissible: false);*/
                                              //PaymentBox();
                                            },
                                            child: Text(
                                              addCreditU,
                                              style: _inkwelTextStyle,
                                            ))),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                    child: Text(
                      transferLogsU,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        //color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    height: MediaQuery.of(context).size.height - 324,
                    child: _isMessageLoading
                        ? Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: themeProvider.getColor,
                              ),
                            ))
                        //: ListBuilder(_items!,themeProvider.getColor),
                        : listHolder(_items!, themeProvider.getColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeProvider.getColor,
        //backgroundColor: Colors.transparent,
        mini: true,
        onPressed: () {
          Navigator.pushNamed(context, CreditRequest.routeName,
          arguments: CreditRequestArgs(credit: credit));
        },
        tooltip: 'Credit',
        child: const Icon(
          Icons.credit_card,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget listHolder(items, theme) {
    return items.isNotEmpty
        ? Column(
            children: [
              Expanded(
                child: ListView.builder(
                    controller: _controller,
                    itemCount: items.length,
                    padding: const EdgeInsets.all(0.0),
                    itemBuilder: (context, item) {
                      return inboxItem(context, items[item], item, theme);
                    }),
              ),
              // when the _loadMore function is running
              if (_isLoadMoreRunning == true)
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme,
                    ),
                  ),
                ),
            ],
          )
        : const Center(child: Text(noMessageU));
  }

  final List<Credit>? _items = [];
  var _isBalanceLoading = false;
  var _isMessageLoading = false;

  void prepareRequest(BuildContext context, _page, _limit) {
    var sender = CreditDataProvider(httpClient: http.Client());
    var res = sender.loadCreditHistory(_page, _limit);
    res.then((value) => {
          if (value.trips!.isNotEmpty)
            {
              setState(() {
                _isMessageLoading = false;
                _isLoadMoreRunning = false;
                _items?.addAll(value.trips ?? []);
              })
            }
          else
            {
              setState(() {
                _isMessageLoading = false;
                _hasNextPage = false;
                _isLoadMoreRunning = false;
              })
            }
        });
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  var creditProvider = CreditDataProvider(httpClient: http.Client());
  var balance = loadingU;
  var credit = "0";

  void reloadBalance() {
    var confirm = creditProvider.loadBalance();
    confirm.then((value) => {
          if (value.code == anAuthorizedC.toString())
            {refreshToken(reloadBalance)}
          else
            {
              setState(() {
                _isBalanceLoading = false;
                balance = value.message.split("|")[0];
                credit = value.message.split("|")[1];
              })
            }
        });
  }

  void refreshToken(Function function) async {
    final res =
        await AuthDataProvider(httpClient: http.Client()).refreshToken();
    if (res.statusCode == 200) {
      function();
    } else {
      gotoSignIn(context);
    }
  }

  Widget inboxItem(BuildContext context, Credit credit, int item, theme) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.18,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          credit.paymentMethod ?? unknownU,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: theme,
                                  border: Border.all(
                                    color: theme,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: SizedBox(
                                width: 5,
                                height: 5,
                              )),
                        ),
                        Text(
                          formatCurrency(credit.amount.toString()),
                          style: const TextStyle(color: Colors.black,fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: theme,
                height: 3,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        credit.message ?? unknownU,
                        style: const TextStyle(color: Colors.black,fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            _formatedDate(credit.date ?? sampleUtcU),
                            style: const TextStyle(color: Colors.black,fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: theme,
                                    border: Border.all(
                                      color: theme,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: const SizedBox(
                                  width: 5,
                                  height: 5,
                                )),
                          ),
                          Text(
                            _status(credit.status ?? unknownU),
                            style: const TextStyle(color: Colors.black,fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _status(String tar) {
    switch (tar) {
      case "1":
        return pendingU;
      case "2":
        return successfulU;
      case "3":
        return timeoutU;
      case "4":
        return canceledU;
      case "5":
        return failedU;
      default:
        return unknownU;
    }
  }

  String _formatedDate(String utcDate) {
    //var str = "2019-04-05T14:00:51.000Z";
    var newStr = utcDate.substring(0, 10) + ' ' + utcDate.substring(11, 23);
    DateTime dt = DateTime.parse(newStr);
    var date = DateFormat(dateFormatU).format(dt);
    return date;
  }

  // At the beginning, we fetch the first 20 posts
  int _page = 1;
  int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isMessageLoading == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 20) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 10; // Increase _page by 1
      prepareRequest(context, _page, _limit);
    }
  }

  // The controller for the ListView
  late ScrollController _controller;
}
