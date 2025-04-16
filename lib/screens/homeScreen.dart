import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:msgboard/screens/profileScreen.dart';
import 'LoginScreen.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder:(context) => LoginScreen())
              );
            },
          )
        ]
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
            )
          ],
        )
      ),
    );
  }
}