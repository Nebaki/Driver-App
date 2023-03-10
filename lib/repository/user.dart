import 'package:driverapp/providers/providers.dart';
import 'package:driverapp/models/models.dart';

class UserRepository {
  final UserDataProvider dataProvider;

  UserRepository({required this.dataProvider});

  Future updateDriverStatus(bool status) async{
    return await dataProvider.updateDriverStatus(status);
  }
  Future<User> createPassenger(User user) async {
    return await dataProvider.createdriver(user);
  }

  Future<User> updatePassenger(User user) async {
    return await dataProvider.updatedriver(user);
  }

  Future<User> updatePreference(User user) async {
    return await dataProvider.updatePreference(user);
  }

  Future<void> deletePassenger(String id) async {
    await dataProvider.deletedriver(id);
  }

  // Future uploadProfilePicture(XFile file) async {
  //   await providers.uploadImage(file);
  // }

  Future<User> getUserById(String id) async {
    return await dataProvider.getDriverById(id);
  }

  Future changePassword(Map<String, String> passwordInfo) async {
    await dataProvider.changePassword(passwordInfo);
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    return await dataProvider.checkPhoneNumber(phoneNumber);
  }

  Future forgetPassword(Map<String, String> forgetPasswordInfo) async {
    await dataProvider.forgetPassword(forgetPasswordInfo);
  }
}
