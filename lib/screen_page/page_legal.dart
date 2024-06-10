import 'package:flutter/material.dart';

class PageLegal extends StatefulWidget {
  const PageLegal({super.key});

  @override
  State<PageLegal> createState() => _PageLegalState();
}

class _PageLegalState extends State<PageLegal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEB3C3C),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Legal and Police',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
// Define action for more_vert button here
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Terms",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome to E-Commerce Application. By accessing our website, you agree to comply with the following terms and conditions.Use of Cookie We use cookies to improve user experience. By using our website, you consent to our use of cookies in accordance with our privacy policy.License Unless otherwise stated, we own the intellectual property rights for all material on our website. You may access this from E-Commerce Application for personal use, subject to restrictions in these terms and conditions.",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                  ),textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Change To The Service and or terms",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Disclaimer To the fullest extent permitted by law, we exclude all warranties and representations related to our website and its use. This disclaimer does not limit or exclude liability for death or personal injury caused by negligence, fraud, or fraudulent misrepresentation. Changes to TermsWe may revise these terms at any time. By using this website, you agree to the current version of these terms and conditions.or more details, please refer to our full Terms and Conditions ",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          )),
    );
  }
}
