import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_frontend/models/product_model.dart';
import 'dart:developer' as logger;

_token() async {
  // Fetch the currentUser, and then get its id token
  final user = await FirebaseAuth.instance.currentUser!;
  final idToken = await user.getIdToken();
  final token = idToken;
  logger.log("idToken $idToken");
  print("idToken $idToken");
  return 'Bearer $token';
}

class ProductService {
  final Dio dio = Dio();

  Future<List<Product>> getProducts() async {
    String productsURL = '';
    if (Platform.isAndroid) {
      productsURL = 'http://10.0.2.2:5001/products';
      // Android-specific code
    } else if (Platform.isIOS) {
      productsURL = 'http://127.0.0.1:5001/products';
      // iOS-specific code
    }

    Map<String, dynamic> header = {
      'Authorization': await _token(),
    };

    List<Product> products;
    try {
      final res = await dio.get(productsURL, options: Options(headers: header));
      products = res.data['products']
          .map<Product>(
            (item) => Product.fromJson(item),
          )
          .toList();
    } on DioError catch (e) {
      products = [];
      logger.log('error get Products: ${e.response?.data}');
    }

    return products;
  }
}
