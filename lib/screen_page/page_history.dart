import 'dart:convert';
import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/model/model_history.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageHistory extends StatefulWidget {
  const PageHistory({super.key});

  @override
  State<PageHistory> createState() => _PageHistoryState();
}

class _PageHistoryState extends State<PageHistory> {
  late String id;
  List<Datum> listhistory = []; // Inisialisasi dengan daftar kosong
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      print('id $id');
    });
    getOrderHistory();
  }

  Future<void> getOrderHistory() async {
    try {
      http.Response res =
          await http.get(Uri.parse('$url/history.php?id_user=$id'));
      if (res.statusCode == 200) {
        setState(() {
          listhistory = modelHisotryFromJson(res.body).data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load order history');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.yellow;
      case 'success':
        return Colors.green;
      default:
        return Colors.grey; // Default color for other statuses
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

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
          'History',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () {
              // Define action for more_vert button here
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : listhistory.isEmpty
              ? Center(
                  child: Text(
                    'Your order history is empty',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: listhistory.length,
                  itemBuilder: (context, index) {
                    Datum history = listhistory[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                                child: Text('Order ID: ${history.orderId}')),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: getStatusColor(history.status),
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              child: Text(
                                history.status,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Waktu: ${formatDate(history.createdAt)}'),
                            Text(history.customerAddress),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
