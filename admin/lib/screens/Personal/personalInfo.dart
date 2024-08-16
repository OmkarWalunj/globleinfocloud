import 'package:flutter/material.dart';
import 'package:globleinfocloud/screens/MobileAuth/authprovider.dart';
import 'package:globleinfocloud/screens/MobileAuth/usermodel.dart';
import 'package:globleinfocloud/theme/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  _PersonalInfo createState() => _PersonalInfo();
}

class _PersonalInfo extends State<PersonalInfo> {
  UserModel? u;
  bool isUserLoaded = false;

  // Loading states for each imag

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final ap = Provider.of<AuthProvider>(context,
        listen: false); // Use the alias

    await ap.getDataFromSP();
    setState(() {
      u = ap.userModel;
      isUserLoaded = true;
      // Set loading states to false once data is fetched
    });
  }

  Future<String> getUserProfilePic() async {
    // Simulate a network call or fetch from a database
    await Future.delayed(const Duration(seconds: 1));
    return u!.addressProof; // Replace with actual URL fetching logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: getData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           
            const SizedBox(height: 20),
            _buildSection1(),
            const SizedBox(height: 20),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection1() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 232, 222, 242),
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
          const SizedBox(height: 20),
          if (isUserLoaded && u != null) ...[
            Row(
              children: [
                Text(
                  "Name : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  u!.name,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Email : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 200,
                  child: Text(
                    u!.email,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Phone No : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  u!.phoneNumber,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ] else ...[
            // Handle the case when user data is loading or not available
            const Text("Loading user data..."),
          ],
          const SizedBox(height: 20),
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
}
