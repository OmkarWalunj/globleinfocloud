import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:globleinfocloud/screens/Home/HomeScreen.dart';
import 'package:globleinfocloud/screens/MobileAuth/authprovider.dart';
import 'package:globleinfocloud/screens/MobileAuth/snackbar.dart';
import 'package:globleinfocloud/screens/MobileAuth/usermodel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';

class UserInfromationScreen extends StatefulWidget {
  const UserInfromationScreen({super.key});

  @override
  State<UserInfromationScreen> createState() => _CustomerRegistrationScreenState();
}


class _CustomerRegistrationScreenState
    extends State<UserInfromationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  File? _addressProof;
  int _currentStep = 0;
  String? _addressProofFileName;
  bool _isLoading = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _fcmToken;

   Future<void> _getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      setState(() {
        _fcmToken = token;
      });
      print("FCM Token: $_fcmToken");
    } catch (e) {
      print("Error fetching FCM token: $e");
    }
  }

  Future<void> _fetchCityAndState(String pinCode) async {
    final response = await http
        .get(Uri.parse('http://www.postalpincode.in/api/pincode/$pinCode'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Status'] == 'Success') {
        setState(() {
          _stateController.text = data['PostOffice'][0]['State'];
          _cityController.text = data['PostOffice'][0]['District'];
        });
      } else {
        print('Error fetching city and state');
      }
    } else {
      print('Network error');
    }
  }

  Future<void> _pickAddressProof() async {
    _addressProof= await pickImage(context);
    if (_addressProof != null) {
      setState(() {
        _addressProofFileName = _addressProof!.path.split('/').last;
      });
    }
    // var status = await Permission.photos.status;
    // if (status.isDenied) {
    //   showSnackBar(context, "Photo permission is required to upload images.");
    //   await Permission.photos.request();
    // } else {
      
    // }
   
  }

 @override
  void initState() {
    super.initState();
    _getToken();
  }
  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _pinCodeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Registration',style: TextStyle( 
          color: Colors.white
        ),),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Theme(
        data: ThemeData(
          primaryColor: Colors.blueGrey,
          colorScheme: ColorScheme.light(
            primary: Colors.blueGrey,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.blueGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueGrey,
            ),
          ),
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep == 2) {
            // Call storeData when in the "Verification" step
            storeData();
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            );
          } else if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
            });
          }
           
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          steps: [
            Step(
              title: Text('Personal Information'),
              content: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Customer Name',
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: _contactController,
                      label: 'Contact Number',
                      icon: Icons.phone,
                    ),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email ID',
                      icon: Icons.email,
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: Text('Address Details'),
              content: Column(
                children: [
                  _buildTextField(
                    controller: _pinCodeController,
                    label: 'Pin Code',
                    icon: Icons.location_on,
                    onChanged: (value) {
                      if (value.length == 6) {
                        _fetchCityAndState(value);
                      }
                    },
                  ),
                  _buildTextField(
                    controller: _stateController,
                    label: 'State',
                    icon: Icons.map,
                    readOnly: true,
                  ),
                  _buildTextField(
                    controller: _cityController,
                    label: 'City',
                    icon: Icons.location_city,
                    readOnly: true,
                  ),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    icon: Icons.home,
                  ),
                ],
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: Text('Verification'),
              content: Column(
                children: [
                  TextButton.icon(
                    onPressed: _pickAddressProof,
                    icon: Icon(Icons.upload_file),
                    label: Text('Upload Address Proof'),
                  ),
                  if (_addressProofFileName != null)
                    Text('Selected: $_addressProofFileName'),
                ],
              ),
              isActive: _currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    bool obscureText = false,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        readOnly: readOnly,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
   void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      addressProof: "",
      createdAt: "",
      phoneNumber: "",
      uid: "",
      pinCode: _pinCodeController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      token: _fcmToken ?? '',
      address: _addressController.text.trim(),
    );

    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _pinCodeController.text.isNotEmpty &&
        _fcmToken != null &&
        _addressController.text.isNotEmpty &&
        _addressProof != null) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        addressProof: _addressProof!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
            (value) => ap.setSignIn().then(
              (value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false,
              ),
            ),
          );
        },
      ).catchError((error) {
        showSnackBar(context, "Error: $error");
      }).whenComplete(() {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      });
    } else {
      showSnackBar(context, "Please upload required (*) documents");
    }
  }
}
