import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_frontend/models/product_model.dart';
import 'dart:developer' as logger;

import 'package:flutter_frontend/models/user_model.dart';

_token() async {
  // Fetch the currentUser, and then get its id token
  final user = await FirebaseAuth.instance.currentUser!;
  final idToken = await user.getIdToken();
  final token = idToken;
  return 'Bearer $token';
}

class UserService {
  final Dio dio = Dio();

  Future setUserRole(userInput) async {
    String userRoleURL = '';
    if (Platform.isAndroid) {
      userRoleURL = 'http://10.0.2.2:5001/userRole';
      // Android-specific code
    } else if (Platform.isIOS) {
      userRoleURL = 'http://127.0.0.1:5001/userRole';
      // iOS-specific code
    }

    Map<String, dynamic> header = {
      'Authorization': await _token(),
    };

    try {
      final res = await dio.post(userRoleURL,
          data: userInput, options: Options(headers: header));
      logger.log('Succes set User Roles $res');
    } on DioError catch (e) {
      logger.log('error Set user Roles: ${e.response?.data}');
    }

    return null;
  }

  Future<List<UserModel>> getUsers() async {
    String getUsersURL = '';
    if (Platform.isAndroid) {
      getUsersURL = 'http://10.0.2.2:5001/users';
    } else if (Platform.isIOS) {
      getUsersURL = 'http://127.0.0.1:5001/users';
    }

    Map<String, dynamic> header = {
      'Authorization': await _token(),
    };

    List<UserModel> users;

    try {
      final res = await dio.get(getUsersURL, options: Options(headers: header));
      users = res.data['users']
          .map<UserModel>(
            (item) => UserModel.fromJson(item),
          )
          .toList();
    } on DioError catch (e) {
      users = [];
      logger.log('error Set user Roles: ${e.response?.data}');
    }

    return users;
  }
}
