import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  Future<void> signUp() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await firestore.collection('users').doc(uid).set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'role': 'user',
        'registrationDateTime': FieldValue.serverTimestamp()
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up successful')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up failed: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}