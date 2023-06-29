import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';
import 'package:flutter_frontend/pages/UserPage.dart';
import 'package:flutter_frontend/services/product_service.dart';
import 'package:flutter_frontend/models/product_model.dart';
import 'package:rive/rive.dart';

import 'dart:developer' as logger;

class OrderFoodPage extends StatefulWidget {
  final List<Product>? products;

  const OrderFoodPage({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<OrderFoodPage> createState() => _OrderFoodPageState();
}

class _OrderFoodPageState extends State<OrderFoodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrderFood Page'),
      ),
      body: ListView.builder(
        itemCount: widget.products?.length,
        itemBuilder: (context, index) {
          var product = widget.products![index];
          return ListTile(
            title: Text(widget.products![index].name),
            subtitle: Text('#${product.id} ${product.description}'),
            trailing: Text('\$${product.price}'),
          );
        },
      ),
    );
  }
}
