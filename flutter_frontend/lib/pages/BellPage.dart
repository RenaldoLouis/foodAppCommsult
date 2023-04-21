import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';

class BellPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: SafeArea(
      //   child: BottomNavigationBarCustom(),
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('BellPage'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          child: Text('Tap Untuk ke AboutPage'),
        ),
      ),
    );
  }
}
