import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome to Movison. This Privacy Policy is designed to help you understand how we collect, use, and safeguard your personal information when you use our mobile application and services.",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                                ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Information We Collect",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '''1. Personal Information:
    * Types of Data Collected:
        - Name
        - Address
        - Identification documents (for verification purposes)
        - Contact information, including email address and phone number
        - Payment information (credit card details, etc.)
2. Usage Data:
    - We may also collect information on how the application is accessed and used ('Usage Data'). This Usage Data may include information such as your device's Internet Protocol address (e.g., IP address), device type, browser type, the pages of our application that you visit, the time and date of your visit, the time spent on those pages, unique device identifiers, and other diagnostic data.''',
                  
                  style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                                ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Use of Data",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "We use the collected data for various purposes, including:\n"
                  "- To provide and maintain our application.\n"
                  "- To process payments and deliver products you have purchased.\n"
                  "- To notify you about changes to our application.\n"
                  "- To provide customer support.\n"
                  "- To monitor the usage of our application.\n"
                  "- To detect, prevent and address technical issues.",
                  textAlign: TextAlign.justify,
                   style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                                ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Disclosure of Data",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "We may disclose your personal data:\n"
                  "- As required by law.\n"
                  "- To comply with legal obligations.\n"
                  "- To protect and defend our rights or property.",
                  textAlign: TextAlign.justify,
                   style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                                ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Security",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure.",
                  textAlign: TextAlign.justify,
                   style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                                ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Contact Us",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "By email: krishakfarma@gmail.com",
                  textAlign: TextAlign.justify,
                   style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                                ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
