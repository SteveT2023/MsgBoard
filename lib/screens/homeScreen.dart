import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:msgboard/screens/profileScreen.dart';
import 'package:msgboard/screens/settingScreen.dart';
import 'package:msgboard/screens/globalChatScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Message Board'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen())
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(Icons.message, size: 30),
              label: Text(
                'Global Chat',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GlobalChatScreen())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}