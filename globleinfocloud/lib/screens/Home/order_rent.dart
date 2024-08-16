import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:globleinfocloud/widgets/razorpay_payment.dart';

class CheckoutScreenBuy extends StatefulWidget {
  late double amount;
  late List<String> bookname=[]; 
  CheckoutScreenBuy(

    {super.key, 
      required this.amount,
      required this.bookname
    }
    );

  @override
  State createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreenBuy> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<String> _paymentOptions = ['Pay Online', 'Cash on Delivery'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: FormBuilder(
                key: _formKey,
                child: ListView(
                  children: [
                    FormBuilderTextField(
                      name: 'fullName',
                      decoration: InputDecoration(labelText: 'Full Name'),
                      validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(
 errorText: 'This field is required.'),
  ]),
                    ),
                    FormBuilderTextField(
                      name: 'address',
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required( errorText: 'This field is required.'),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'city',
                      decoration: InputDecoration(labelText: 'City'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required( errorText: 'This field is required.'),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'zipCode',
                      decoration: InputDecoration(labelText: 'Zip Code'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required( errorText: 'This field is required.'),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'phoneNumber',
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'This field is required.'),
                      ]),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    FormBuilderRadioGroup(
                      name: 'paymentMethod',
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      options: _paymentOptions.map((option) => FormBuilderFieldOption(value: option, child: Text(option))).toList(),
                      validator: FormBuilderValidators.required( errorText: 'This field is required.'),
                    ),
                   
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _onCheckoutPressed,
                        child: Text('Place Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCheckoutPressed() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      final paymentMethod = formData?['paymentMethod'];

      print('Form Data: $formData');

      // Handle order submission based on payment method
      if (paymentMethod == 'Pay Online') {
        // Example: Redirect to payment gateway or handle online payment
        bool paymentSuccessful = await _processOnlinePayment();
        if (paymentSuccessful) {

          await _saveOrderToFirebase(formData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order placed successfully with online payment!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment failed, please try again.')),
          );
        }
      } else if (paymentMethod == 'Cash on Delivery') {
        await _saveOrderToFirebase(formData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed successfully with cash on delivery!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid payment method selected.')),
        );
      }
    } else {
      print('Form is invalid');
    }
  }

  Future<bool> _processOnlinePayment() async {
    // Simulate an online payment process
    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RazorpayPayment (
                          amount:widget.amount,
                          bookName :widget.bookname, 
                        ),
                      ),
                    );
    await Future.delayed(Duration(seconds: 2));
    return true; // Simulate a successful payment
  }

  Future<void> _saveOrderToFirebase(Map<String, dynamic>? formData) async {
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'Bookname':widget.bookname,
        'fullName': formData?['fullName'],
        'address': formData?['address'],
        'city': formData?['city'],
        'zipCode': formData?['zipCode'],
        'phoneNumber': formData?['phoneNumber'],
        'paymentMethod': formData?['paymentMethod'],
        'totalAmount': widget.amount,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }
}