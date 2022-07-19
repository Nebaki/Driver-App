import 'dart:convert';
// import 'package:dio/dio.dart';
import 'package:driverapp/helper/api_end_points.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/dataprovider/auth/auth.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/helper/api_end_points.dart' as api;

class UserDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/drivers';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  UserDataProvider({required this.httpClient});

  Future updateDriverStatus(bool status) async {
    final http.Response response = await httpClient.post(
        Uri.parse(api.UserEndPoints.changeStatusEndPoint(status)),
        body: json.encode({"status": status}),
        headers: <String, String>{
          'Content-Type': "application/json",
          'x-access-token': '${await authDataProvider.getToken()}',
        });
    if (response.statusCode != 200) {
      throw Exception(response.statusCode);
    }
  }

  Future<User> getDriverById(String id) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/get-driver/$id'), headers: <String, String>{
      'Content-Type': "application/json",
      'x-access-token': '${await authDataProvider.getToken()}',
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return User.fromJson(responseData);
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return getDriverById(id);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception('Failed to get driver.');
    }
  }

  Future<User> createdriver(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-driver'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'name': user.firstName,
        'email': user.email,
        'gender': user.gender,
        'password': user.password,
        'phone_number': user.phoneNumber,
        'emergency_contact': user.emergencyContact,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  // Future uploadImage(XFile file) async {
  //   final request = http.MultipartRequest(
  //       'POST', Uri.parse('$_baseUrl/update-profile-image'));
  //   request.headers['x-access-token'] = '${await authDataProvider.getToken()}';
  //   request.files.add(await http.MultipartFile.fromPath(
  //     "profile_image",
  //     file.path.toString(),
  //     contentType: MediaType('image', 'jpg'),
  //   ));
  //   final response = await request.send();

  //   if (response.statusCode == 200) {
  //     await response.stream.transform(utf8.decoder).listen((value) async {
  //       final data = jsonDecode(value);
  //       await authDataProvider.updateProfile(data['driver']['profile_image']);
  //     });

  //     // var resp = await response.stream.transform(utf8.decoder).listen.;
  //     // print(resp);

  //     //final data = jsonDecode(response.);
  //     //return User.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to upload image.');
  //   }
  // }

  Future<void> deletedriver(String id) async {
    final http.Response response = await httpClient.delete(
        Uri.parse('$_baseUrl/delete-driver/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: {});

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user.');
    }
  }

  Future<User> updatedriver(User user) async {
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl/update-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'
      },
      body: jsonEncode(<String, dynamic>{
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'gender': user.gender,
        'phone_number': user.phoneNumber,
        'emergency_contact': user.emergencyContact,
        'preference': user.preference
      }),
    );
    if (response.statusCode == 200) {
      authDataProvider.updateUserData(user);
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return updatedriver(user);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception('Failed to update user.');
    }
  }

  Future updatePreference(User user) async {
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl/update-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'
      },
      body: jsonEncode(<String, dynamic>{'preference': user.preference}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      authDataProvider.updatePreference(
          data['driver']['preference']['gender'],
          data['driver']['preference']['min_rate'].toString(),
          data['driver']['preference']['car_type']);
    } else if (response.statusCode != 204) {
      throw Exception('204 Failed to update user.');
    } else {
      throw Exception('Failed to update user.');
    }
  }

  Future changePassword(Map<String, String> passwordInfo) async {
    final http.Response response =
        await http.post(Uri.parse('$maintenanceUrl/drivers/change-password'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'x-access-token': '${await authDataProvider.getToken()}',
            },
            body: json.encode({
              'current_password': passwordInfo['current_password'],
              "new_password": passwordInfo['new_password'],
              "confirm_password": passwordInfo['confirm_password']
            }));
    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        final res =
            await AuthDataProvider(httpClient: httpClient).refreshToken();

        if (res.statusCode == 200) {
          return changePassword(passwordInfo);
        } else {
          throw Exception(response.statusCode);
        }
      } else {
        throw 'Unable to change password';
      }
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    final http.Response response = await http.get(
      Uri.parse(UserEndPoints.checkPhonenumberEndPoint(phoneNumber)),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return checkPhoneNumber(phoneNumber);
      } else {
        throw Exception(response.statusCode);
      }
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw 'Unable to check the phonenumber';
    }
  }

  Future forgetPassword(Map<String, String> forgetPasswordInfo) async {
    final http.Response response =
        await http.post(Uri.parse(UserEndPoints.forgetPasswordEndPoint()),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'phone_number': forgetPasswordInfo['phone_number'],
              'newPassword': forgetPasswordInfo['new_password']
            }));
    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        final res =
            await AuthDataProvider(httpClient: httpClient).refreshToken();

        if (res.statusCode == 200) {
          return forgetPassword(forgetPasswordInfo);
        } else {
          throw Exception(response.statusCode);
        }
      } else {
        throw 'Unable to rest password';
      }
    }
  }
}


// image upload with dio

// var dio = Dio();

    // dio.interceptors
    //     .add(InterceptorsWrapper(onRequest: (option, handler) async {
    //   print("Yowwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");

    //   option.headers['x-access-token'] = await authDataProvider.getToken();

    //   return handler.next(option);
    // }, onResponse: (response, handler) {
    //   print("Yowwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
    //   print(response.statusMessage);
    //   return handler.next(response);
    // }, onError: (error, handler) {
    //   print(error);
    //   return handler.next(error);
    // }));
    // final formData = FormData.fromMap({
    //   'profile_image': await MultipartFile.fromFile(file.path,
    //       contentType: MediaType('image', 'jpg'))
    // });

    //   final response = await dio.post(
    //     '$_baseUrl/update-profile-image',
    //     data: formData,
    //   );
    //   print(response.statusCode);
