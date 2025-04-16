import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            firstName = userDoc['firstName'] ?? 'No First Name';
            lastName = userDoc['lastName'] ?? 'No Last Name';
          });
        }
      }
    } catch (e) {
      print('Fetching user data failed: $e');
    }
  }

  Future<void> updateFirstName(String newFirstName) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'firstName': newFirstName});
        setState(() {
          firstName = newFirstName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('First name updated.')),
        );
      }
    } catch (e) {
      print('Error updating first name: $e');
    }
  }

  Future<void> updateLastName(String newLastName) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'lastName': newLastName});
        setState(() {
          lastName = newLastName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Last name updated.')),
        );
      }
    } catch (e) {
      print('Error updating last name: $e');
    }
  }

  void ChangeFName() {
    final TextEditingController ChangeFNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change First Name'),
          content: TextField(
            controller: ChangeFNameController,
            decoration: const InputDecoration(
              labelText: 'Enter New First Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newFirstName = ChangeFNameController.text.trim();
                if (newFirstName.isNotEmpty) {
                  updateFirstName(newFirstName);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('First name cannot be empty.')),
                  );
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void ChangeLName() {
    final TextEditingController ChangeLNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Last Name'),
          content: TextField(
            controller: ChangeLNameController,
            decoration: const InputDecoration(
              labelText: 'Enter New Last Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newLastName = ChangeLNameController.text.trim();
                if (newLastName.isNotEmpty) {
                  updateLastName(newLastName);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Last name cannot be empty.')),
                  );
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const CircleAvatar(
              backgroundColor: Colors.orangeAccent,
              radius: 80,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              '$firstName $lastName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: ChangeFName,
              child: const Text('Change First Name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ChangeLName,
              child: const Text('Change Last Name'),
            ),
          ],
        ),
      ),
    );
  }
}