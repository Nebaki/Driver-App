import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotificationDialog extends StatelessWidget {
  final Function callback;
  final Function setDestination;
  final Function setIsArrivedWidget;

  NotificationDialog(
    this.callback,
    this.setDestination,
    this.setIsArrivedWidget,
  );
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "New Ride Request",
        style: TextStyle(fontSize: 14),
      ),
      content: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.request_page,
                size: 50,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text("Pickup : MeskelFlower"),
            const SizedBox(
              height: 10,
            ),
            const Text("Drop Off: Bole"),
            const SizedBox(
              height: 30,
            ),
            const Divider()
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(width: 1, color: Colors.red))),
                onPressed: () {},
                child: const Text("Cancel")),
            ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(244, 201, 60, 1)),
                ),
                onPressed: () {
                  DirectionEvent event =
                      DirectionLoad(destination: LatLng(8.9211232, 38.7663361));

                  BlocProvider.of<DirectionBloc>(context).add(event);

                  setIsArrivedWidget(true);
                  setDestination(LatLng(8.9211232, 38.7663361));
                  callback(Arrived(callback));

                  Navigator.pop(context);
                },
                child: const Text(
                  "Accept",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ))
          ],
        )
      ],
    );
  }
}
