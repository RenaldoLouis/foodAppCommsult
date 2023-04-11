import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';
import 'package:flutter_frontend/pages/UserPage.dart';
import 'package:flutter_frontend/product_service.dart';
import 'package:flutter_frontend/product_model.dart';
import 'package:flutter_frontend/utils/riveUtils.dart';
import 'package:rive/rive.dart';

import '../components/AnimatedBar.dart';
import '../models/RiveAssets.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _productService = ProductService();
  RiveAsset selectedBottomNav = bottomNavs.first;

  @override
  Widget build(BuildContext context) {
    const title = 'Product List';

    return Scaffold(
      // theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
      body: Scaffold(
        bottomNavigationBar: SafeArea(
          child: BottomNavigationBarCustom(),
        ),
        appBar: AppBar(
          title: const Text(title),
        ),
        body: FutureBuilder<List<Product>>(
          future: _productService.getProducts(),
          builder: (context, snapshot) {
            var products = snapshot.data ?? [];

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return ListTile(
                  title: Text(products[index].name),
                  subtitle: Text('#${product.id} ${product.description}'),
                  trailing: Text('\$${product.price}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}