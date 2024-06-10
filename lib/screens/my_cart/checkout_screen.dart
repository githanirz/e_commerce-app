import 'dart:convert';
import 'package:app_ecommerce/model/model_checkout.dart';
import 'package:app_ecommerce/model/model_listcart.dart';
import 'package:app_ecommerce/screens/my_cart/payment_detail.dart';
import 'package:flutter/material.dart';
import 'package:app_ecommerce/const.dart';
// import 'package:app_ecommerce/model/model_listaddtocart.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Datum> products;
  final int total;

  const CheckoutScreen({Key? key, required this.products, required this.total})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? address, username, email, id;
  bool isLoading = false;
  String? snap;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("email");
      address = pref.getString("address");
      username = pref.getString("username");
      id = pref.getString("id");
    });
  }

  Future<void> placeOrder() async {
    try {
      setState(() {
        isLoading = true;
      });

      var jsonData = jsonEncode({
        'user_id': id,
        'items': widget.products.map((item) {
          return {
            'id': item.productId,
            'product_name': item.productName,
            'product_price': item.productPrice,
            'product_stock': item.productStock,
          };
        }).toList(),
        'customer_address': address,
        // 'total_price': widget.total.toString(),
      });

      final response = await http.post(
        Uri.parse('$url/api.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['snap_token'] != null &&
            responseData['order_id'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentDetail(
                snapToken: responseData['snap_token'],
                orderId: responseData['order_id'],
              ),
            ),
          );
        } else {
          _showErrorDialog('Failed to place order. Incomplete response.');
        }
      } else {
        _showErrorDialog('Failed to place order. Server error.');
      }
    } catch (e) {
      _showErrorDialog('Failed to place order. ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  String formatCurrency(int amount) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 40),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username ?? 'House',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email ?? 'No address found',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Product List Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Product',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                Datum product = widget.products[index];
                return ListTile(
                  leading: SizedBox(
                    width: 57,
                    height: 57,
                    child: Image.network(
                      '$url/gambar/${product.productImage}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(product.productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatCurrency(int.parse(product.productPrice)),
                      ),
                      Text('Quantity: ${product.productStock}'),
                    ],
                  ),
                );
              },
            ),
          ),
          // Payment Method Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.payment, size: 40),
            title: Text('Credit/Debit Card'),
            subtitle: Text(address ?? 'user****@gmail.com'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Payment method logic
            },
          ),
          // Total Amount Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              formatCurrency(widget.total),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Checkout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  placeOrder();
                },
                child: Text('Checkout Now'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
