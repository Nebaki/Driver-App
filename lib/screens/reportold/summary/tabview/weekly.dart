// import 'package:driverapp/widgets/widgets.dart';
// import 'package:flutter/material.dart';

// class WeeklySummaryTab extends StatelessWidget {
//   const WeeklySummaryTab({Key? key}) : super(key: key);

//   Color getColor(BuildContext context, double percent) {
//     if (percent >= 0.50) {
//       return Theme.of(context).primaryColor;
//     } else if (percent >= 0.25) {
//       return Colors.orange;
//     }
//     return Colors.red;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         Container(
//           padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
//           color: Colors.white,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 200,
//                 child: CustomScrollView(
//                   slivers: <Widget>[
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                         (BuildContext context, int index) {
//                           if (index == 0) {
//                             return const WeeklyEarningBarChart(
//                                 [8, 12, 3, 14, 5, 16, 7]);
//                           }
//                         },
//                         childCount: 1 + 7,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 0),
//                 child: Divider(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: const [Text("15"), Text("Trips")],
//                     ),
//                     const VerticalDivider(),
//                     Column(
//                       children: const [Text("8:30"), Text("Online hrs")],
//                     ),
//                     const VerticalDivider(),
//                     Column(
//                       children: const [Text("\$22.48"), Text("Cash Trips")],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         const Padding(
//           padding: EdgeInsets.only(left: 40),
//           child: Text("Trips"),
//         ),
//         Column(
//           children: List.generate(
//               8,
//               (index) => _buildTrips(
//                   time: "3:32", location: "AratKillo", price: "40")),
//         )
//       ],
//     );
//   }

//   Widget _buildTrips(
//       {required String time, required String location, required String price}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           ListTile(
//             leading: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [Text(time), const Text("AM")]),
//             title: Text(location),
//             subtitle: const Text("Paid in Cash"),
//             trailing: Text("\$$price"),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 50, right: 10),
//             child: Divider(),
//           )
//         ],
//       ),
//     );
//   }
// }