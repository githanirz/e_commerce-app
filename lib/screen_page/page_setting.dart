import 'package:app_ecommerce/main.dart';
import 'package:app_ecommerce/screen_page/page_legal.dart';
import 'package:app_ecommerce/screens/login_register/login_screen.dart';
import 'package:app_ecommerce/screens/profile/editprofile_screen.dart';
import 'package:app_ecommerce/utils/cek_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageSetting extends StatefulWidget {
  const PageSetting({super.key});

  @override
  State<PageSetting> createState() => _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  // Fungsi untuk menghapus sesi dan navigasi ke halaman login
  Future<void> clearSession() async {
    bool confirmLogout = await showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Logout'),
        content: Text('Ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ya'),
          ),
        ],
      ),
    );

    if (confirmLogout) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEB3C3C),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BottomNavBar(initialIndex: 3),
              ),
            );
          },
        ),
        title: Text(
          'Setting',
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
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "General",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageEditProfile(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(
                      15), // Adjust the value for more or less rounding
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(), // Untuk memberikan ruang di antara teks dan ikon
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Preferences",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageLegal(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(
                      15), // Adjust the value for more or less rounding
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(Icons.security_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Legal and Policies',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(), // Untuk memberikan ruang di antara teks dan ikon
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(
                        "Are you sure you want to logout?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 22),
                      ),
                      actions: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text(
                                "Cancel",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                session.clearSession(); // Clear session data
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                  (Route<dynamic> route) => false,
                                ); // Navigate to login screen and remove all previous routes
                              },
                              child: Text(
                                "Log Out",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                        15), // Adjust the value for more or less rounding
                  ),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.login_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 240,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
