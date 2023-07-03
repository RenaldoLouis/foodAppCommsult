import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';
import 'package:flutter_frontend/models/user_model.dart';
import 'package:flutter_frontend/pages/OrderFood.dart';
import 'package:flutter_frontend/pages/UserListPage.dart';
import 'package:flutter_frontend/pages/UserPage.dart';
import 'package:flutter_frontend/services/product_service.dart';
import 'package:flutter_frontend/models/product_model.dart';
import 'package:flutter_frontend/services/user_service.dart';
import 'package:rive/rive.dart';

import '../../components/AnimatedBar.dart';
import '../../models/RiveAssets.dart';
import 'dart:developer' as logger;

class HomePage extends StatefulWidget {
  final User? user;

  HomePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _productService = ProductService();
  final _userService = UserService();
  RiveAsset selectedBottomNav = bottomNavs.first;
  var idTokenResult;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var tempIdTokenResult = await widget.user?.getIdTokenResult(true);
      if (mounted) {
        setState(() {
          idTokenResult = tempIdTokenResult;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Product List';
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(title),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            _productService.getProducts(),
            _userService.getUsers(),
          ]),
          builder: (context, snapshot) {
            var products;
            var users;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Text('Error: ${snapshot.error}');
            } else {
              products = snapshot.data![0] as List<Product>;
              users = snapshot.data![1] as List<UserModel>;
            }

            return Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return OrderFoodPage(products: products);
                              }));
                            },
                            child: const Text('Order Food'),
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder()),
                          ),
                        ),
                        SizedBox(
                            width:
                                16), // Adjust the spacing as per your requirements
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('List Table'),
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder()),
                          ),
                        ),
                        SizedBox(
                            width:
                                16), // Adjust the spacing as per your requirements
                        idTokenResult?.claims['role'] == "user"
                            ? Container()
                            : Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return UserListPage(users: users);
                                    }));
                                  },
                                  child: const Text('List Users'),
                                  style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder()),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
