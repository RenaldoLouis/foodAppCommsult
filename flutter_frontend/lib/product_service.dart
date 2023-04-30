import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_frontend/product_model.dart';
import 'dart:developer' as logger;

_token() async {
  // Fetch the currentUser, and then get its id token
  final user = await FirebaseAuth.instance.currentUser!;
  final idToken = await user.getIdToken();
  final token = idToken;
  return 'Bearer $token';
}

class ProductService {
  final String productsURL = 'http://10.0.2.2:5000/products';
  final Dio dio = Dio();

  ProductService();

  Future<List<Product>> getProducts() async {
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
