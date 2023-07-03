import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';
import 'package:flutter_frontend/models/user_model.dart';
import 'package:flutter_frontend/pages/UserPage.dart';
import 'package:flutter_frontend/services/product_service.dart';
import 'package:flutter_frontend/models/product_model.dart';
import 'package:rive/rive.dart';

import 'dart:developer' as logger;

class UserListPage extends StatefulWidget {
  final List<UserModel>? users;

  const UserListPage({Key? key, required this.users}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrderFood Page'),
      ),
      body: ListView.builder(
        itemCount: widget.users?.length,
        itemBuilder: (context, index) {
          var product = widget.users![index];
          return ListTile(
            title: Text(widget.users![index].Name),
            subtitle: Text('#${product.Role} ${product.Disabled}'),
            trailing:
                ElevatedButton(onPressed: () {}, child: Text("assign user")),
          );
        },
      ),
    );
  }
}
