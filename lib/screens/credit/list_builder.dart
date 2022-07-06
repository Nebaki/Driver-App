import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/credit/credit.dart';
import '../../utils/constants/ui_strings.dart';

class ListBuilder extends StatelessWidget {
  List<Credit> items;
  Color theme;
  ListBuilder(this.items, this.theme, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return items.isNotEmpty
        ? ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(0.0),
            itemBuilder: (context, item) {
              return _inboxItem(context, items[item], item);
            })
        : const Center(child: Text(noMessageU));
  }

  Widget _inboxItem(BuildContext context, Credit credit, int item) {
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
                          credit.paymentMethod ?? "Unknown",
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
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: SizedBox(
                                width: 5,
                                height: 5,
                              )
                          ),
                        ),
                        Text(
                          "${credit.amount} ETB",
                          style:
                              const TextStyle(color: Colors.black),
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
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        credit.message ?? "Unknown",
                        style: const TextStyle(color: Colors.black),
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
                          Text(_formatedDate(credit.date ?? "2022-04-20T11:47:17.092Z"),
                            style:
                                const TextStyle(color: Colors.black),
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
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: SizedBox(
                                  width: 5,
                                  height: 5,
                                )
                            ),
                          ),
                          Text(
                            _status(credit.status ?? "Unknown"),
                            style:
                                const TextStyle(color: Colors.black),
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
  String _status(String tar){
    switch(tar){
      case "1" :return "Pending";
      case "2" :return "Successful";
      case "3" :return "Timeout";
      case "4" :return "Canceled";
      case "5" :return "Failed";
      default :return "Unknown";
    }
  }
  String _formatedDate(String utcDate){
    //var str = "2019-04-05T14:00:51.000Z";
    var newStr = utcDate.substring(0,10) + ' ' + utcDate.substring(11,23);
    DateTime dt = DateTime.parse(newStr);
    var date = DateFormat("EEE, d MMM yyyy HH:mm:ss").format(dt);
    return date;
  }

  Widget _buildListItems(BuildContext context, Credit credit, int item) {
    return Card(
        elevation: 2,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                //ShowToast(context, items[item].amount!).show();
                showModalBottomSheet<void>(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return _showBottomMessage(context, credit);
                    });
              },
              leading: Icon(
                credit.type == "Gift" ? Icons.wallet_giftcard : Icons.email,
                size: 40,
              ),
              title: Text(
                credit.message!,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              subtitle: Text('${credit.type} . ${credit.date}'),
              trailing: Text('${credit.amount}',
                  style: const TextStyle(color: Colors.red)),
            ),
          ],
        ));
  }

  Widget _showBottomMessage(BuildContext context, Credit credit) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ListTile(
            leading: Icon(
              credit.type == "Gift" ? Icons.wallet_giftcard : Icons.email,
              size: 50,
            ),
            title: Text(
              credit.title!,
              style: const TextStyle(fontSize: 22, color: Colors.red),
            ),
            subtitle: Text(credit.date!),
            trailing:
                Text(credit.amount!, style: const TextStyle(color: Colors.red)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                credit.message!,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Divider(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Payed with: ",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              credit.paymentMethod ?? "Unknown",
                              style: const TextStyle(
                                  color: Colors.deepOrangeAccent),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "status: ",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              credit.status ?? "Unknown",
                              style: const TextStyle(
                                  color: Colors.deepOrangeAccent),
                            ),
                          ],
                        ),
                        /*Row(
                                  children: [
                                    Text("Status: ${credit.paymentMethod!},"
                                        " ${credit.status!}, ${credit.depositedBy!.name!}"),
                                  ],
                                ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
