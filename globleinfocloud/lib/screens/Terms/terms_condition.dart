import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
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
                Container(
                  child: Text(
                    "These Terms and Conditions govern your use of MoViSon's mobile application . By accessing or using the App, you agree to be bound by these Terms and Conditions.",
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                  ),
                ),
               
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    '''
1. Rental Services

- Book Rentals: MoViSon offers engineering textbooks for rent through the App.
  
- Rental Period: The minimum rental period is 5 months. Rental fees are 20 INR per month per book.
  
- Deposit: A refundable deposit of 100 INR per book is required upon renting, which will be refunded upon return of the book in good condition.
  
- Quality Check: Returned books undergo a quality check. The deposit will be refunded based on the condition of the book.

2. Purchase Services

- Book Purchases: You may purchase engineering textbooks directly through the App.

3. User Responsibilities

- Account Registration: You must create an account to use certain features of the App. You are responsible for maintaining the confidentiality of your account credentials.
  
- Prohibited Activities: You agree not to engage in any prohibited activities, including but not limited to unauthorized use of the App, violation of intellectual property rights, and unlawful activities.

4. Privacy

- Privacy Policy: Your use of the App is also governed by our Privacy Policy, which describes how we collect, use, and disclose your information.

5. Limitation of Liability

- Disclaimer: MoViSon is not liable for any damages resulting from the use or inability to use the App, including but not limited to direct, indirect, incidental, or consequential damages.

6. Changes to Terms

- Modification: MoViSon may update these Terms and Conditions from time to time. We will notify you of any changes by posting the revised Terms and Conditions on this page.

7. Governing Law

- Jurisdiction: These Terms and Conditions shall be governed by and construed in accordance with the laws of Indian government, without regard to its conflict of law provisions.

8. Contact Us
-By email: krishakfarma@gmail.com
''',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
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
