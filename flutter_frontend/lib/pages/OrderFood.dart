import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';
import 'package:flutter_frontend/pages/UserPage.dart';
import 'package:flutter_frontend/services/product_service.dart';
import 'package:flutter_frontend/models/product_model.dart';
import 'package:rive/rive.dart';

import 'dart:developer' as logger;

class OrderFoodPage extends StatefulWidget {
  const OrderFoodPage({Key? key}) : super(key: key);

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
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('List of food Here'),
        ),
      ),
    );
  }
}
