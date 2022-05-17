import 'package:flutter/material.dart';

import '../../models/credit/credit.dart';

class ListBuilder extends StatelessWidget {
  List<Credit> items;

  ListBuilder(this.items, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return items.isNotEmpty
        ? ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(0.0),
            itemBuilder: (context, item) {
              return _buildListItems(context, items[item], item);
            })
        : const Center(child: Text('No Message'));
  }

  Widget _buildListItems(BuildContext context, Credit credit, int item) {
    return Card(
        elevation: 4,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                //ShowToast(context, items[item].amount!).show();
                showModalBottomSheet<void>(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)
                      ),
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
                credit.title!,
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
          Text(
            credit.message!,
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            credit.paymentMethod!,
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            credit.status!,
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            credit.depositedBy!.name!,
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            credit.depositedBy!.phone!,
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            credit.depositedBy!.email!,
            style: const TextStyle(color: Colors.black),
          ),

        ],
      ),
    );
  }
}
