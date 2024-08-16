import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading orders'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders available'));
          }

          List<DocumentSnapshot> orders = snapshot.data!.docs;

          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(order['fullName']),
                  subtitle: Text('Total: ${order['totalAmount']}'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(
                          orderId: orders[index].id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? orderData;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  void _fetchOrderDetails() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('orders').doc(widget.orderId).get();
      setState(() {
        orderData = snapshot.data() as Map<String, dynamic>?;
      });
    } catch (e) {
      print('Error fetching order details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch order details.')),
      );
    }
  }

  void _acceptOrder() async {
    try {
      await _firestore
          .collection('orders')
          .doc(widget.orderId)
          .update({'status': 'accepted'});
      _sendNotification('Your order has been accepted!');
    } catch (e) {
      print('Error accepting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept the order.')),
      );
    }
  }

  void _rejectOrder() async {
    try {
      await _firestore
          .collection('orders')
          .doc(widget.orderId)
          .update({'status': 'rejected'});
      _sendNotification('Your order has been rejected.');
    } catch (e) {
      print('Error rejecting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject the order.')),
      );
    }
  }

  void _sendNotification(String message) {
    // Here you would implement the notification sending functionality
    // For example, using Firebase Cloud Messaging (FCM)
    print('Notification sent to customer: $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: orderData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: ${widget.orderId}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Full Name: ${orderData!['fullName']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Address: ${orderData!['address']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'City: ${orderData!['city']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Zip Code: ${orderData!['zipCode']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Phone Number: ${orderData!['phoneNumber']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Payment Method: ${orderData!['paymentMethod']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  
                  Text(
                    'Total Amount: ${orderData!['totalAmount']}',
                    style: TextStyle(fontSize: 16),
                  ),
                   Text(
                    'Full Name: ${orderData!['Bookname']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _acceptOrder,
                        child: Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _rejectOrder,
                        child: Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
