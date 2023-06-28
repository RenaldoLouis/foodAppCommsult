import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/AnimatedBar.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';
import 'package:flutter_frontend/models/RiveAssets.dart';
import 'package:flutter_frontend/pages/BellPage.dart';
import 'package:flutter_frontend/pages/ChatPage.dart';
import 'package:flutter_frontend/pages/HomePage/HomePage.dart';
import 'package:flutter_frontend/pages/SettingsPage.dart';
import 'package:flutter_frontend/pages/UserPage.dart';
import 'package:rive/rive.dart';
import 'dart:developer';

class ContainerApp extends StatefulWidget {
  User? user;

  ContainerApp({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ContainerApp> createState() => _ContainerAppState();
}

class _ContainerAppState extends State<ContainerApp> {
  RiveAsset selectedBottomNav = bottomNavs.first;

  int _currentIndex = 0;
  late final List<Widget> _pages = [
    HomePage(
      user: widget.user,
    ),
    ChatPage(),
    Userpage(
      user: widget.user,
    ),
    BellPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBarCustom(
          selectedIndex: _currentIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}
