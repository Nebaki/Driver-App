import 'package:driverapp/providers/providers.dart';
import 'package:driverapp/models/models.dart';

class RatingRepository {
  const RatingRepository({required this.ratingDataProvider});
  final RatingDataProvider ratingDataProvider;

  Future<Rating> getMyRating() async {
    return await ratingDataProvider.getMyRating();
  }
}
