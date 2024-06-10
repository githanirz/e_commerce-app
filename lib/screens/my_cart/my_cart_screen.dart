import 'package:app_ecommerce/model/model_listcart.dart';
import 'package:flutter/material.dart';
import 'package:app_ecommerce/const.dart';
import 'package:http/http.dart' as http;
import 'package:increment_decrement_form_field/increment_decrement_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'checkout_screen.dart'; // Import CheckoutScreen

class MyCartScreen extends StatefulWidget {
  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  String? username, id;
  bool isLoading = false;

  late List<Datum> _allCart = [];
  late Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
      id = pref.getString("id") ?? '';
    });
    getProduct();
  }

  Future<void> getProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res =
          await http.get(Uri.parse('$url/listaddtocart.php?id_user=$id'));
      List<Datum> data = modelListCartFromJson(res.body).data ?? [];
      setState(() {
        _allCart = data;
        _quantities = {
          for (var item in _allCart) item.productId: 1,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$url/deletelistaddtocart.php'),
        body: {'id_product': productId, 'id_user': id},
      );
      if (res.statusCode == 200) {
        setState(() {
          _allCart.removeWhere((item) => item.productId == productId);
          _quantities.remove(productId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product deleted successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete product")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String formatCurrency(int amount) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(amount);
  }

  int calculateTotalPrice() {
    int totalPrice = 0;
    for (int i = 0; i < _allCart.length; i++) {
      int price = int.tryParse(_allCart[i].productPrice ?? '') ?? 0;
      int quantity = _quantities[_allCart[i].productId] ?? 1;
      totalPrice += price * quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = calculateTotalPrice();
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'My Cart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _allCart.isEmpty
                ? Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: _allCart.length,
                    itemBuilder: (context, index) {
                      Datum product = _allCart[index];
                      int price = int.tryParse(product.productPrice ?? '') ?? 0;
                      int quantity = _quantities[product.productId] ?? 1;
                      return Card(
                        color: Colors.white,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              deleteProduct(product.productId);
                            },
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                          title: Row(
                            children: [
                              SizedBox(
                                width: 57,
                                height: 57,
                                child: Image.network(
                                  '$url/gambar/${product.productImage}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.productName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        IncrementDecrementFormField<int>(
                                          initialValue:
                                              _quantities[product.productId] ??
                                                  1,
                                          displayBuilder: (value, field) {
                                            return Text(
                                              value == null
                                                  ? "0"
                                                  : value.toString(),
                                            );
                                          },
                                          onDecrement: (currentValue) {
                                            int newValue = (currentValue! > 1)
                                                ? currentValue - 1
                                                : 1;
                                            setState(() {
                                              _quantities[product.productId] =
                                                  newValue;
                                              _allCart[index].productStock =
                                                  newValue;
                                            });
                                            return newValue;
                                          },
                                          onIncrement: (currentValue) {
                                            int newValue = currentValue! + 1;
                                            setState(() {
                                              _quantities[product.productId] =
                                                  newValue;
                                              _allCart[index].productStock =
                                                  newValue;
                                            });
                                            return newValue;
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                formatCurrency(price * quantity),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _allCart.isEmpty
                      ? 'Total: ${formatCurrency(0)}'
                      : 'Total: ${formatCurrency(totalPrice)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _allCart.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  products: _allCart,
                                  total: totalPrice,
                                ),
                              ),
                            );
                          },
                    icon: Icon(Icons.shopping_cart),
                    label: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFEB3C3C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
