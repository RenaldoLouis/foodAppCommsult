import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/BellPage.dart';
import 'package:flutter_frontend/pages/ChatPage.dart';
import 'package:flutter_frontend/pages/ContainerApp.dart';
import 'package:flutter_frontend/pages/SplashScreen.dart';
import 'package:flutter_frontend/pages/HomePage.dart';
import 'package:flutter_frontend/pages/SettingsPage.dart';
import 'package:flutter_frontend/pages/UserPage.dart';
import 'package:flutter_frontend/product_service.dart';
import 'package:flutter_frontend/product_model.dart';
import 'package:rive/rive.dart';

import 'components/AnimatedBar.dart';
import 'models/RiveAssets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _productService = ProductService();
  RiveAsset selectedBottomNav = bottomNavs.first;

  @override
  Widget build(BuildContext context) {
    const title = 'Product List';

    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomePage(),
        // '/user': (context) => Userpage(),
        '/settings': (context) => SettingsPage(),
        '/bell': (context) => BellPage(),
        '/chat': (context) => ChatPage(),
      },
      title: title,
      home: SplashScreen(),
    );
  }
}
