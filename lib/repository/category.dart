import 'package:driverapp/dataProvider/data_providers.dart';
import 'package:driverapp/models/models.dart';

class CategoryRepository {
  final CategoryDataProvider categoryDataProvider;
  const CategoryRepository({required this.categoryDataProvider});
  Future<Category> getCategoryById(String id) async {
    return await categoryDataProvider.getCategoryById(id);
  }
}