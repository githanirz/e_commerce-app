import 'dart:async';
import 'package:app_ecommerce/screen_page/on_boarding.dart';
import 'package:app_ecommerce/screens/home/home_screen.dart';
import 'package:app_ecommerce/screens/login_register/register_screen.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OnBoardingScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints:
              BoxConstraints.expand(), // Mengisi seluruh ruang yang tersedia
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                Color(0xffEB3C3C),
                Color(0xff852222)
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 80),
              //   child: Text(
              //     "TokoKU",
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 40,
              //         color: Colors.white),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Center(
                child: 
                Image.asset("images/logo.png")
              ),
              // Text(
              //   "Version 1.0.1",
              //   style: TextStyle(
              //       fontWeight: FontWeight.w400,
              //       fontSize: 12,
              //       color: Colors.white),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
