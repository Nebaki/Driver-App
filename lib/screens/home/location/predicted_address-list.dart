import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/models/models.dart';

class PredictedItems extends StatelessWidget {
  const PredictedItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationPredictionBloc, LocationPredictionState>(
      builder: (context, state) {
        if (state is LocationPredictionLoading) {}
        if (state is LocationPredictionLoadSuccess) {
          return ListView.separated(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (cont, index) {
                return _buildPredictedItem(
                    state.placeList[index], context, context);
              },
              separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: Colors.black38),
                  ),
              itemCount: state.placeList.length);
        }

        return Container();
      },
    );
  }

  void getPlaceDetail(String placeId, BuildContext context) {
    PlaceDetailEvent event = PlaceDetailLoad(placeId: placeId);
    BlocProvider.of<PlaceDetailBloc>(context).add(event);
  }

  Widget _buildPredictedItem(
      LocationPrediction prediction, con, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          getPlaceDetail(prediction.placeId, context);
        },
        child: Container(
          color: Colors.black.withOpacity(0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 12,
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(flex: 6, child: Text(prediction.mainText)),
            ],
          ),
        ),
      ),
    );
  }
}
