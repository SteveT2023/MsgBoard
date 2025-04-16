import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalChatScreen extends StatelessWidget {
  const GlobalChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Global Chat'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final timestamp = (message['timestamp'] as Timestamp?)?.toDate();
                    return ListTile(
                      title: Text(message['message']),
                      subtitle: Text(
                        '${message['firstName']} ${message['lastName']} --- ${timestamp != null ? timestamp.toLocal().toString() : 'Unknown time'}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (messageController.text.isNotEmpty) {
                      final user = auth.currentUser;
                      if (user != null) {
                        final userDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .get();

                        final firstName = userDoc['firstName'] ?? 'Unknown';
                        final lastName = userDoc['lastName'] ?? 'User';

                        await FirebaseFirestore.instance.collection('messages').add({
                          'message': messageController.text,
                          'firstName': firstName,
                          'lastName': lastName,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        messageController.clear();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}