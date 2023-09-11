import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';
import 'package:flutter_frontend/models/user_model.dart';
import 'package:flutter_frontend/pages/ChatPage/ChatPage.dart';
import 'package:flutter_frontend/pages/UserPage.dart';
import 'package:flutter_frontend/services/product_service.dart';
import 'package:flutter_frontend/models/product_model.dart';
import 'package:rive/rive.dart';

import 'dart:developer' as logger;

class UserListPage extends StatefulWidget {
  final List<UserModel>? users;
  final User? user;

  const UserListPage({Key? key, required this.users, required this.user})
      : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final defaultProfileImage = "assets/images/profile.png";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List Page'),
      ),
      body: ListView.builder(
        itemCount: widget.users?.length,
        itemBuilder: (context, index) {
          var product = widget.users![index];
          return ListTile(
            title: Text(widget.users![index].Name),
            subtitle: Text('#${product.Role} ${product.Disabled}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Assign user"),
                ),
                SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ChatPage(
                        userUid: "AJlEJEsybdVa4DbrjNmIwPRPdz02",
                        peerId: widget.users![index].UID,
                        peerAvatar: defaultProfileImage,
                        peerNickname: widget.users![index].Name,
                        userAvatar: defaultProfileImage,
                        user: widget.user,
                      );
                    }));
                  },
                  child: Text("Chat user"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
