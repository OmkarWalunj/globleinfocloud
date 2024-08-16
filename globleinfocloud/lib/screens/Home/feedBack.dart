
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Use an alias

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _feedbackController = TextEditingController();
 

  void _submitFeedback() async {
    String feedback = _feedbackController.text.trim();
   final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    
 // log(currentUserId!);
    
    if (currentUserId != null) {
      if (feedback.isNotEmpty) {
        try {
          await FirebaseFirestore.instance.collection('feedback').add({
            'feedback': feedback,
            'timestamp': Timestamp.now(),
            'userId': currentUserId,
          });

          // Clear the TextField
          _feedbackController.clear();

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Feedback submitted successfully!'),
            ),
          );
        } catch (e) {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit feedback: $e'),
            ),
          );
        }
      } else {
        // Show an error message if the TextField is empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter your feedback before submitting.'),
          ),
        );
      }
    } else {
      // Show an error message if the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to submit feedback.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chat With Us'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 300,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 232, 222, 242),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: _buildBody(),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: _submitFeedback,
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 143, 122, 194),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            "Give your feedback or suggest any changes",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(3),
            child: TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your feedback',
              ),
            ),
          ),
        ],
      ),
    );
  }
}