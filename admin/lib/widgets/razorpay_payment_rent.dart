import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globleinfocloud/screens/Payment/paymenthist.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RazorpayPaymentRent extends StatefulWidget {
  final double amount;
  final List<String> bookName;

  const RazorpayPaymentRent(
      {Key? key, required this.amount, required this.bookName})
      : super(key: key);

  @override
  State createState() => RazorpayPaymentState();
}

class RazorpayPaymentState extends State<RazorpayPaymentRent> {
  late DateTime _currentDateTime;
  late Razorpay _razorpay;
  User? user = FirebaseAuth.instance.currentUser;
  String currentUid = '';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    _currentDateTime = DateTime.now();
    currentUid = user!.uid;
  }

  void openCheckout() async {
    var options = {
      'key': '',
      'amount': (widget.amount+40+(widget.bookName.length*100)) * 100,
      'name': 'Omkar Ramdas Walunj',
      'prefill': {'contact': '8767886904', 'email': 'omkarwalunj1704@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : e');
    }
  }

  Future<void> savePaymentHistory(String status, String paymentId) async {
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String time = DateFormat('kk:mm').format(DateTime.now());

    // Define your Firestore collection reference
    CollectionReference paymentHistoryCollection =
        FirebaseFirestore.instance.collection('paymentHistory');

    // Prepare the payment data
    Map<String, dynamic> paymentData = {
      'userId': currentUid,
      'status': status,
      'paymentId': paymentId,
      'amount': widget.amount, // Assuming widget.amount is accessible here
      'bookName':
          widget.bookName, // Assuming widget.bookName is accessible here
      'date': date,
      'time': time,
    };

    try {
      // Add the payment data to Firestore
      await paymentHistoryCollection.add(paymentData);
      print('Payment history saved successfully!');
    } catch (e) {
      print('Failed to save payment history: $e');
      // Handle any errors here
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    savePaymentHistory('Success', response.paymentId!);
    Fluttertoast.showToast(
        msg: "Payment Successful ${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    savePaymentHistory('Failure', response.code.toString());
    Fluttertoast.showToast(
        msg: "Payment Failed ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<List<Map<String, dynamic>>> getPaymentHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String paymentHistory = prefs.getString('paymentHistory') ?? '[]';
    List<dynamic> paymentHistoryList = jsonDecode(paymentHistory);
    return paymentHistoryList
        .map((item) => item as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay Payment Rent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentHistoryScreen(
                    currentUserId: currentUid,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: GestureDetector(
          onTap: openCheckout,
          child: Container(
            width: 200,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 185, 27, 233)),
            child: Text(
              "Pay ₹${widget.amount+40+(widget.bookName.length*100)}",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //height: 250,
                width: 400,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 222, 242),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 143, 143, 143),
                          offset: Offset(0, 7),
                          blurRadius: 5)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          'Book Name : ',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          // height:60,
                          width: 150,
                          child: Text(
                            "${widget.bookName}",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          'Date : ',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('dd-MM-yyyy').format(_currentDateTime),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          'Time :',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('kk:mm').format(_currentDateTime),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        SizedBox(width: 30),
                        Text(
                          'Delivery Charges :',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "₹40",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          'Deposite (₹100 per book) :',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "₹${widget.bookName.length*100}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          'Total amount :',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "₹${widget.amount+40+(widget.bookName.length*100)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
