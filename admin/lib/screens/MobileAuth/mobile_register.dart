
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globleinfocloud/screens/MobileAuth/authprovider.dart';
import 'package:globleinfocloud/screens/MobileAuth/custom_button_in_mobile_auth.dart';


import 'package:provider/provider.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
   bool isLoading = false;

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.05,
                horizontal: screenWidth * 0.1,
              ),
              child: Column(
                children: [
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF7EFE5),
                    ),
                    child: Image.asset("assets/AuthImages/smartphone.png"),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Add your phone number. We'll send you a verification code",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
              TextFormField(
  cursorColor: Colors.orangeAccent,
  controller: phoneController,
  keyboardType: TextInputType.phone,
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  onChanged: (value) {
    setState(() {
      phoneController.text = value;
      if (value.length == 10) {
        FocusScope.of(context).unfocus();
      }
    });
  },
  decoration: InputDecoration(
    hintText: "Enter phone number",
    hintStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: Colors.grey.shade600,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black12),
    ),
    prefixIcon: Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 4,
          ),
          InkWell(
            onTap: () {
              showCountryPicker(
                context: context,
                countryListTheme: const CountryListThemeData(
                  bottomSheetHeight: 550,
                ),
                onSelect: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
              );
            },
            child: Text(
              "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
    suffixIcon: phoneController.text.length > 9
        ? Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: const Icon(
              Icons.done,
              color: Colors.white,
              size: 20,
            ),
          )
        : null,
  ),
),
   const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child: CustomButton(
                      text: "Login",
                      onPressed: () => sendPhoneNumber(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (isLoading)
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

   void sendPhoneNumber() async {
    isLoading = true;
    setState(() {
      
    });

    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();

    try {
      await ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
      // Navigate to OTP page or other success actions here
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}