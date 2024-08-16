
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globleinfocloud/screens/History/history.dart';
import 'package:globleinfocloud/screens/MobileAuth/authprovider.dart' as movision;
import 'package:globleinfocloud/screens/MobileAuth/mobile_register.dart';
import 'package:globleinfocloud/screens/MobileAuth/usermodel.dart';
import 'package:globleinfocloud/screens/Payment/paymenthist.dart';
import 'package:globleinfocloud/screens/Personal/personalInfo.dart';
import 'package:globleinfocloud/screens/Privacy/privacypolicy.dart';
import 'package:globleinfocloud/screens/Terms/terms_condition.dart';
import 'package:globleinfocloud/theme/color.dart';
import 'package:globleinfocloud/widgets/profile_pic.dart';
import 'package:globleinfocloud/widgets/setting_item.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserModel? u;
  bool isUserLoaded = false;

  Future<void> getData() async {
   final ap = Provider.of<movision.AuthProvider>(context); // Use the alias

    await ap.getDataFromSP();
    setState(() {
      u = ap.userModel;
      isUserLoaded = true;
     
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile',style: TextStyle(
            color: AppColor.textColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),),
        
      ),
      body: _buildBody(),
    );
  }


  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh:getData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            _buildSection1(),
            const SizedBox(
              height: 20,
            ),
            _buildSection2(),
            const SizedBox(
              height: 20,
            ),
            _buildSection3(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return RefreshIndicator(
      onRefresh:getData,
      child: Column(
        children: [
          const ProfilePic(),
          const SizedBox(
            height: 10,
          ),
          if (u != null) ...[
            Text(
              u!.name,
              style:const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            // Handle the case when u or u.name is null
            const Text("User name not available"),
          ],
        ],
      ),
    );
  }


  Widget _buildSection1() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          if (u != null) ...[
            SettingItem(
                title: "Personal Info",
                leadingIcon: "assets/icons/contact_phone.svg",
                bgIconColor: AppColor.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PersonalInfo()),
                  );
                }),
            _buildDivider(),
            SettingItem(
              title: "History",
              leadingIcon: "assets/icons/wallet.svg",
              bgIconColor: AppColor.green,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                     builder: (context) => HistoryScreen(currentUserId: u!.userId,),
                  ),
                );
              },
            ),
            _buildDivider(),
            SettingItem(
              title: "Payment",
              leadingIcon: "assets/icons/wallet.svg",
              bgIconColor: AppColor.green,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                     builder: (context) => PaymentHistoryScreen(currentUserId: u!.userId,),
                  ),
                );
              },
            ),
            _buildDivider(),
          ] else ...[
            // Handle the case when u is null
            const Text("Loading user data..."),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Divider(
        height: 0,
        color: Colors.grey.withOpacity(0.8),
      ),
    );
  }

  Widget _buildSection2() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          SettingItem(
            title: "Terms & Conditions",
            leadingIcon: "assets/icons/bell1.svg",
            bgIconColor: AppColor.purple,
            onTap: (){
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Divider(
              height: 0,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          SettingItem(
            title: "Privacy",
            leadingIcon: "assets/icons/shield.svg",
            bgIconColor: AppColor.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
              );
            },
          ),
          _buildDivider(),
          const SettingItem(
            title: "Help Center",
            leadingIcon: "assets/icons/bell1.svg",
            bgIconColor: AppColor.purple,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Divider(
              height: 0,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildSection3() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: AppColor.cardColor,
      boxShadow: [
        BoxShadow(
          color: AppColor.shadowColor.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
    ),
    child: SettingItem(
      title: "Log Out",
      leadingIcon: "assets/icons/logout.svg",
      bgIconColor: AppColor.darker,
      onTap: () async {
        await _showLogoutConfirmationDialog(context);
      },
    ),
  );
}

Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap a button
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to log out?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Logout'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                (route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}

}
