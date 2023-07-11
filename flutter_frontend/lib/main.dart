import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/BellPage.dart';
import 'package:flutter_frontend/pages/ChatPage.dart';
import 'package:flutter_frontend/pages/ContainerApp.dart';
import 'package:flutter_frontend/pages/SplashScreen.dart';
import 'package:flutter_frontend/pages/HomePage/HomePage.dart';
import 'package:flutter_frontend/pages/SettingsPage.dart';
import 'package:flutter_frontend/pages/UserPage.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';
import 'package:flutter_frontend/providers/chat_provider.dart';
import 'package:flutter_frontend/providers/profile_provider.dart';
import 'package:flutter_frontend/services/product_service.dart';
import 'package:flutter_frontend/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/AnimatedBar.dart';
import 'models/RiveAssets.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  RiveAsset selectedBottomNav = bottomNavs.first;

  @override
  Widget build(BuildContext context) {
    const title = 'Product List';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
              firebaseAuth: FirebaseAuth.instance,
              firebaseFirestore: firebaseFirestore,
              prefs: widget.prefs),
        ),
        Provider(
          create: (_) => ChatProvider(
              firebaseFirestore: firebaseFirestore,
              prefs: widget.prefs,
              firebaseStorage: firebaseStorage),
        ),
        Provider(
          create: (_) => ProfileProvider(
              firebaseFirestore: firebaseFirestore,
              prefs: widget.prefs,
              firebaseStorage: firebaseStorage),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        // routes: <String, WidgetBuilder>{
        //   '/home': (context) => HomePage(),
        //   '/user': (context) => Userpage(),
        //   '/settings': (context) => SettingsPage(),
        //   '/bell': (context) => BellPage(),
        //   '/chat': (context) => ChatPage(),
        // },
        // title: title,
        home: SplashScreen(),
      ),
    );
  }
}
