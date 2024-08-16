import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentHistoryScreen extends StatelessWidget {
  final String currentUserId;

  const PaymentHistoryScreen({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('paymentHistory')
            .where('userId', isEqualTo: currentUserId)
            .orderBy('date', descending: true)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Book Purchase history found.'));
          }

          List<Map<String, dynamic>> paymentHistory = snapshot.data!.docs.map((doc) {
            return {
              'bookName': doc['bookName'],
              'date': doc['date'],
              'time': doc['time'],
              'amount': doc['amount'],
              'status': doc['status'],
            };
          }).toList();

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: paymentHistory.length,
            itemBuilder: (context, index) {
              final payment = paymentHistory[index];
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 196, 240),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 165, 164, 164),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text("${payment['bookName']}"),
                  subtitle: Text(
                    'Date: ${payment['date']}\nTime: ${payment['time']}',
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "₹${payment['amount']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        payment['status'],
                        style: TextStyle(
                          color: payment['status'] == 'Failure' ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
