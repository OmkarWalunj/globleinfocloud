import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:globleinfocloud/screens/Home/HomeScreen.dart';
import 'package:globleinfocloud/screens/MobileAuth/mobile_register.dart';
import 'package:globleinfocloud/screens/MobileAuth/snackbar.dart';
import 'package:globleinfocloud/size_config.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToHome();
    checkNetworkStatus();
  }
  Future<void> checkNetworkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      showSnackBar(context, "Warning: You are using mobile data.");
    } else if (connectivityResult == ConnectivityResult.none) {
      showSnackBar(context, "No internet connection");
    }
  }
  Future<void> _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 2000));
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    print("-------------------------------------");
    print(data);

    // Check if the user is already signed in
    if (data != '') {
      // User is signed in, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()), // Replace HomeScreen with the actual home screen
      );
    } else {
      // User is not signed in, navigate to RegisterScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Material(
      color: Colors.white, // Set the background color here
      child: GestureDetector(
        onTap: () {
          // Handle tap by navigating to the appropriate screen
          _navigateToHome();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Text(
                  'GlobleInfoCloud',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(36),
                    color: Color.fromARGB(255, 47, 86, 231),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
