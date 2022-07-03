import 'package:driverapp/models/models.dart';
import 'package:driverapp/repository/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit({required this.ratingRepository}) : super(RatingLoading());
  final RatingRepository ratingRepository;

  void getMyRating() async {
    emit(RatingLoading());
    try {
      final rating = await ratingRepository.getMyRating();
      emit(RatingLoadSuccess(rating));
    } catch (e) {
      if (e.toString().split(" ")[1] == "401") {
        emit(RatingUnAuthorised());
      } else {
        emit(RatingOperationFailure());
      }
    }
  }
}

abstract class RatingState extends Equatable {}

class RatingLoading extends RatingState {
  @override
  List<Object?> get props => [];
}

class RatingLoadSuccess extends RatingState {
  final Rating rating;
  RatingLoadSuccess(this.rating);
  @override
  List<Object?> get props => [rating];
}

class RatingOperationFailure extends RatingState {
  @override
  List<Object?> get props => [];
}

class RatingUnAuthorised extends RatingState {
  @override
  List<Object?> get props => [];
}
