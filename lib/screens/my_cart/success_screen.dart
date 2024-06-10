import 'dart:convert';
import 'package:app_ecommerce/screen_page/page_notif.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/main.dart';
import 'package:app_ecommerce/model/model_add.dart';
import 'package:app_ecommerce/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SuccessPage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final int? orderId;
  SuccessPage(this.orderId, {super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  bool isLoading = false;
  String? id, username;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      // print('id $id');
    });
  }

  String baseUrl = '$url';
  Future<void> deleteData(String? id, int? orderid) async {
    final url = Uri.parse('$baseUrl/success.php');
    final Map<String, dynamic> data = {'id_user': id, 'order_id': orderid};

    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'success') {
          print('Data deleted successfully!');
        } else {
          print('Failed to delete data: ${decodedResponse['message']}');
        }
      } else {
        print('Error deleting data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting data: $error');
    }
  }

  Future<ModelAddjms?> update() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/success.php'),
          body: {"order_id": widget.orderId.toString(), "id_user": id});
      ModelAddjms data = modelAddjmsFromJson(res.body);
      if (data.isSuccess == true) {
        setState(() {
          isLoading = false;
          // Show notification after navigating to Home screen
          Noti.showBigTextNotification(
              title: "Pembayaran Sukses",
              body: "Pembayaran Anda telah berhasil.",
              fln: widget.flutterLocalNotificationsPlugin);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavBar()),
              (route) => false);
        });
      } else if (data.isSuccess == false) {
        setState(() {
          isLoading = false;
          setState(() {});
        });
      } else {
        setState(() {
          isLoading = false;
          setState(() {});
        });
      }
    } catch (e) {
      //munculkan error
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // getProduct();
    getSession();
    // update();
    super.initState();
    Noti.initialize(widget.flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  update();
                  Noti.showBigTextNotification(
                      title: "New message title",
                      body: "Your long body",
                      fln: widget.flutterLocalNotificationsPlugin);
                },
                child: Text('Back to Home')),
          ],
        )
      ]),
    );
  }
}
