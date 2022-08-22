import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/bloc/daily_earning/daily_earning_bloc.dart';
import 'package:driverapp/cubits/cubits.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OnDriverStatus extends StatelessWidget {
  final bool isOnline;
  const OnDriverStatus({Key? key, required this.isOnline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: BlocBuilder<DailyEarningBloc, DailyEarningState>(
              builder: (context, state) {
                if (state is DailyEarningLoadSuccess) {
                  return _items(
                      num: '${state.dailyEarning.totalEarning} ETB',
                      text: "Earning",
                      icon: Icons.money,context: context);
                }

                if (state is DailyEarningLoading) {
                  return _buildShimmer(text: "Earning", icon: Icons.money,context: context);
                }
                if (state is DailyEarningOperationFailure) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          flex: 2,
                          child: Icon(
                            Icons.error_outline_outlined,
                            color: themeProvider.getColor,
                          )),
                      const Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          "error...",
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: TextButton(
                              onPressed: () {
                                context.read<DailyEarningBloc>().add(DailyEarningLoad());
                              },
                              child: const Text("Retry"))),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),

          VerticalDivider(
            color: Colors.grey.shade300,
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: BlocBuilder<RatingCubit, RatingState>(
              builder: (context, state) {
                if (state is RatingLoadSuccess) {
                  return _items(
                      num: state.rating.score.toStringAsFixed(1),
                      text: "Rating",
                      icon: Icons.star,context: context);
                }

                if (state is RatingLoading) {
                  return _buildShimmer(text: "Rating", icon: Icons.star,context: context);
                }
                if (state is RatingOperationFailure) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          flex: 2,
                          child: Icon(
                            Icons.error_outline_outlined,
                            color: themeProvider.getColor,
                          )),
                      const Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          "error...",
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: TextButton(
                              onPressed: () {
                                context.read<RatingCubit>().getMyRating();
                              },
                              child: const Text("Retry"))),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
          VerticalDivider(
            color: Colors.grey.shade300,
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: BlocBuilder<BalanceBloc, BalanceState>(
              builder: (context, state) {
                if (state is BalanceLoadSuccess) {
                  return _items(
                      num: "${state.balance} ETB",
                      text: "Credit",
                      icon: Icons.wallet_giftcard,context: context);
                }
                if (state is BalanceLoading) {
                  return _buildShimmer(
                      text: "Credit", icon: Icons.wallet_giftcard,context: context);
                }

                if (state is BalanceOperationFailure) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          flex: 2,
                          child: Icon(
                            Icons.error_outline_outlined,
                            color: themeProvider.getColor,
                          )),
                      const Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          "errpor...",
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: TextButton(
                              onPressed: () {
                                context.read<BalanceBloc>().add(BalanceLoad());
                              },
                              child: const Text("Retry"))),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _items(
      {required String num, required String text, required IconData icon,required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.all(5),
              color: Provider.of<ThemeProvider>(context, listen: false).getColor,
              child: Icon(
                icon,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          Text(
            num,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.black38,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }

  Widget _buildShimmer({required String text, required IconData icon,required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.all(5),
              color: Provider.of<ThemeProvider>(context, listen: false).getColor,
              child: Icon(
                icon,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          Shimmer(
            gradient: shimmerGradient,
            child: Container(
                height: 20,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16))),
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.black38,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }
}
