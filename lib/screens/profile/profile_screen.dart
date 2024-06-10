import 'package:app_ecommerce/screen_page/page_history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_ecommerce/main.dart';
import 'package:app_ecommerce/screen_page/page_setting.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String? id, username, email, address;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  @override
  void didUpdateWidget(ProfilScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id");
      username = pref.getString("username");
      email = pref.getString("email");
      address = pref.getString("address");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Spacer(
                    flex: 4,
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                  ),
                  Spacer(flex: 1),
                  Spacer(flex: 1),
                  Spacer(
                      flex:
                          1), // Memberikan fleksibilitas agar teks "Profile" lebih ke kanan
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => PageSetting(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'images/profile.jpg'), // Ganti dengan gambar avatar pengguna
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Username',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 25,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        '$username',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Email',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 25,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        '$address',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Address',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 25,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        '$email',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PageHistory(), // Navigate to PageHistory
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffEB3C3C), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Button border radius
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_sharp),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'View History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
