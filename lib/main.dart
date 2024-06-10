import 'package:app_ecommerce/screen_page/page_notif.dart';
import 'package:app_ecommerce/screen_page/splashscreen.dart';
import 'package:app_ecommerce/screens/home/favorit_screen.dart';
import 'package:app_ecommerce/screens/home/home_screen.dart';
import 'package:app_ecommerce/screens/login_register/login_screen.dart';
import 'package:app_ecommerce/screen_page/splashscreen.dart';
import 'package:app_ecommerce/screens/login_register/register_screen.dart';
import 'package:app_ecommerce/screens/my_cart/my_cart_screen.dart';
import 'package:app_ecommerce/screens/profile/profile_screen.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E Commerce App',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, foregroundColor: Colors.white),
        ),
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
            backgroundColor: Color(0xffEB3C3C),
            iconTheme: IconThemeData(color: Colors.white)),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final int initialIndex; // Tambahkan initialIndex
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  BottomNavBar({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  List<Widget> body = [
    Icon(Icons.home_filled),
    Icon(Icons.delivery_dining_outlined),
    Icon(Icons.favorite),
    Icon(Icons.person_2),
  ];

  final screen = [
    HomeScreen(),
    MyCartScreen(),
    FavoriteScreen(),
    ProfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget
        .initialIndex; // Atur _currentIndex dengan initialIndex dari widget
    Noti.initialize(widget.flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.delivery_dining_outlined), label: "My Order"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "My Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        backgroundColor:
            Colors.white, // Warna latar belakang BottomNavigationBar
        selectedItemColor: Colors.red, // Warna item yang dipilih
        unselectedItemColor: Colors.grey, // Warna item yang tidak dipilih
        type: BottomNavigationBarType.fixed, // Jenis BottomNavigationBar
      ),
    );
  }
}
