import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBarCustom(),
      ),
      appBar: AppBar(
        title: Text('ChatPage'),
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