import 'package:driverapp/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerDailySummary extends StatelessWidget {
  const ShimmerDailySummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Total balance",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              Shimmer(
                gradient: shimmerGradient,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: 60,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(24)),
                    )),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Divider(),
              ),
              Shimmer(
                gradient: shimmerGradient,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.black),
                      ),
                      const VerticalDivider(),
                      Container(
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.black),
                      ),
                      const VerticalDivider(),
                      Container(
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 40),
          child: Text("Trips"),
        ),
        Column(
          children: List.generate(8, (index) => _buildTrips(context)),
        )
      ],
    );
  }

  Widget _buildTrips(BuildContext context) {
    return Shimmer(
      gradient: shimmerGradient,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(24)),
              height: 80,
              width: MediaQuery.of(context).size.width,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50, right: 10),
              child: Divider(),
            )
          ],
        ),
      ),
    );
  }
}
