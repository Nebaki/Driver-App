import 'package:image_picker/image_picker.dart';
import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/models/models.dart';
import 'dart:io';

class UserRepository {
  final UserDataProvider dataProvider;

  UserRepository({required this.dataProvider});

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

  Future uploadProfilePicture(XFile file) async {
    await dataProvider.uploadImage(file);
  }

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
