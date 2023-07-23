import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';
import 'package:flutter_frontend/pages/Login/login_screen.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: SafeArea(
      //   child: BottomNavigationBarCustom(),
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Settings Page'),
      ),
      body: Center(
          // child: ElevatedButton(
          //   onPressed: () {
          //     FirebaseAuth.instance.signOut();
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(
          //         builder: (context) => LoginScreen(),
          //       ),
          //     );
          //   },
          //   child: Text('Signout'),
          // ),
          ),
    );
  }
}
