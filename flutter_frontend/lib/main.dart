import 'package:flutter/material.dart';
import 'package:flutter_frontend/product_service.dart';
import 'package:flutter_frontend/product_model.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    const title = 'Product List';

    return MaterialApp(
      title: title,
      // theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
      home: Scaffold(
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(left: 24, right: 25, bottom: 2),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                RiveAnimation.asset("assets/RiveAssets/home.riv"),
              ],
            ),
          ),
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
                    trailing: Text('\$${product.price}'));
              },
            );
          },
        ),
      ),
    );
  }
}
