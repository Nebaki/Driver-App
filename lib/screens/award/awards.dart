import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';

// import 'package:driverapp/helper/localization.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:animated_background/animated_background.dart';

import 'package:intl/intl.dart';
import '../../dataprovider/auth/auth.dart';
import '../../dataprovider/lottery/lottery.dart';
import '../../models/lottery/award.dart';
import '../../models/lottery/ticket.dart';
import '../../utils/constants/ui_strings.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';
import '../credit/toast_message.dart';
import 'package:http/http.dart' as http;

class AwardScreen extends StatefulWidget {
  static const routeName = '/award';

  AwardScreen({Key? key}) : super(key: key);

  @override
  State<AwardScreen> createState() => _AwardScreenState();
}

class _AwardScreenState extends State<AwardScreen> with AutomaticKeepAliveClientMixin<AwardScreen> {
  final _appBar = GlobalKey<FormState>();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // need to call super method.
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
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
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        //color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    height: MediaQuery.of(context).size.height,
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
    );
  }

  @override
  void initState() {
    _isMessageLoading = true;
    prepareRequest(context, 0, _limit);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _controller = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  String _formatedDate(String utcDate) {
    //var str = "2019-04-05T14:00:51.000Z";
    var newStr = utcDate.substring(0, 10) + ' ' + utcDate.substring(11, 23);
    DateTime dt = DateTime.parse(newStr);
    var date = DateFormat(dateFormatU).format(dt);
    return date;
  }

  late ThemeProvider themeProvider;

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

  final List<Award>? _items = [];
  var _isMessageLoading = false;

  void prepareRequest(BuildContext context, _page, _limit) {
    var lottery = LotteryDataProvider(httpClient: http.Client());
    var res = lottery.loadLotteryAwards(_page, _limit);
    res.then((value) => {
          if (value.awards!.isNotEmpty)
            {
              setState(() {
                _isMessageLoading = false;
                _isLoadMoreRunning = false;
                _items?.addAll(value.awards ?? []);
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

  var balance = loadingU;

  void refreshToken(Function function) async {
    final res =
        await AuthDataProvider(httpClient: http.Client()).refreshToken();
    if (res.statusCode == 200) {
      function();
    } else {
      gotoSignIn(context);
    }
  }

  Widget inboxItem(BuildContext context, Award award, int item, theme) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.23,
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
                          award.title ?? unknownU,
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
                              child: const SizedBox(
                                width: 5,
                                height: 5,
                              )),
                        ),
                        Text(
                          award.isActive ?? false ? "Active" : "InActive",
                          style: const TextStyle(color: Colors.black),
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
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          award.description ?? unknownU,
                          style: const TextStyle(color: Colors.black,
                              overflow: TextOverflow.visible),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                          Text("From: ",style: TextStyle(color: themeProvider.getColor)),
                          Text(
                            _formatedDate(award.startDate ?? sampleUtcU),
                            style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
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
                          Row(
                            children: [
                              Text("To: ",style: TextStyle(color: themeProvider.getColor)),
                              Text(
                                _formatedDate(award.endDate ?? sampleUtcU),
                                style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              ),
                            ],
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
}
