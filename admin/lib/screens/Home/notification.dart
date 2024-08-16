import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String? currentUserIdphone = FirebaseAuth.instance.currentUser?.phoneNumber;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _notificationController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // @override
  // void initState() {
  //   super.initState();
  //   requestNotificationPermission();
  //   initializeFirebaseMessaging();
  // }

  Future<void> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notification permission granted.");
    } else {
      print("Notification permission denied.");
    }
  }

  Future<void> initializeFirebaseMessaging() async {
    // Request permission for iOS devices
    await _firebaseMessaging.requestPermission();

    // Get the token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Handle the incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground: ${message.messageId}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked! Message data: ${message.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('notifications').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final notifications = snapshot.data!.docs;

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = notifications[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 239, 188, 241),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 150, 150, 150),
                          blurRadius: 3,
                          offset: Offset(-3, 3),
                        )
                      ],
                    ),
                    child: Text(notification['text']),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:(currentUserIdphone == "+918767886904" || currentUserIdphone == "+917057702200") ? Container(
        height: 50,
        width: 150,
        child: FloatingActionButton(
          onPressed: () => _showBottomSheet(context),
          child: const Text("Add Notifications"),
        ),
      ):null,
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // To handle keyboard
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add a new notification",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _notificationController,
                  decoration: const InputDecoration(
                    labelText: "Notification",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 188, 241),
                  ),
                  onPressed: () => _addNotification(context),
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addNotification(BuildContext context) async {
    String notificationText = _notificationController.text.trim();
    User? user = _auth.currentUser;

    if (user != null && notificationText.isNotEmpty) {
      try {
        await _firestore.collection('notifications').add({
          'text': notificationText,
          'timestamp': Timestamp.now(),
          'userId': user.uid,
        });

        // Clear the TextField
        _notificationController.clear();

        // Close the bottom sheet
        Navigator.pop(context);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification added successfully!'),
          ),
        );
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add notification: $e'),
          ),
        );
      }
    } else {
      // Show an error message if the TextField is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a notification before adding.'),
        ),
      );
    }
  }
}