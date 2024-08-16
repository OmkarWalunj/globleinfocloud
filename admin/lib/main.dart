import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:globleinfocloud/routes.dart';
import 'package:globleinfocloud/screens/MobileAuth/authprovider.dart';
import 'package:globleinfocloud/screens/splash/splash_screen.dart';



import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
     // Initialize Firebase App
  await Firebase.initializeApp(
    options: Platform.isAndroid
        ? const FirebaseOptions(
            apiKey: 'AIzaSyBUIIzxV7tAqpyZHKhjLqvnuAnHA5K6Qok',
            appId: '1:831009989819:android:93781c9bc5b0fece4b359e',
            messagingSenderId: '831009989819',
            projectId: 'globleinfocloud',
            storageBucket: 'globleinfocloud.appspot.com',
          )
        : null,
  );

  // Activate Firebase App Check
 
    runApp(const MyApp());
 

  

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: routes,
      ),
    );
  }
}
