import 'package:app_ecommerce/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_ecommerce/model/model_product.dart';
import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/screens/home/detail_product_screen.dart';
import 'package:app_ecommerce/model/model_insertfav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryCasual extends StatefulWidget {
  const CategoryCasual({Key? key}) : super(key: key);

  @override
  State<CategoryCasual> createState() => _CategoryCasualState();
}

class _CategoryCasualState extends State<CategoryCasual> {
  List<Datum>? products;
  bool isLoading = true;
  String? id;
  Set<String> favoriteProductIds = {};

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
    });
  }

  Future<void> getProduct() async {
    try {
      http.Response res = await http.get(Uri.parse('$url/getCategoryCasual.php'));
      products = modelProductFromJson(res.body).data;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  Future<void> addFav(String productId) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$url/insertfavorite.php'),
        body: {
          "id_user": id!,
          "id_product": productId,
        },
      );

      ModelInsertFavorite data = modelInsertFavoriteFromJson(res.body);

      if (data.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Item dimasukkan ke favorit"),
          backgroundColor: Colors.green,
        ));

        setState(() {
          favoriteProductIds.add(productId);
        });

        // Navigasi ke BottomNavBar setelah menambahkan item ke favorit
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Item sudah ada di favorit: ${data.message}"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Item sudah ada di favorit"),
        backgroundColor: Colors.red,
      ));
    }
  }


  @override
  void initState() {
    super.initState();
    getSession();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black), // Menggunakan icon arrow back iOS
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Sneakers', style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(8.0),
              childAspectRatio: 0.75,
              children: List.generate(products!.length, (index) {
                Datum product = products![index];
                bool isFavorite = favoriteProductIds.contains(product.id);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProductScreen(product: product),
                        ),
                      );
                    },
                    child: 
                      Card(
                        color: Colors.white,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Image.network(
                                    '$url/gambar/${product.productImage}',
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: 150.0,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () {
                                      addFav(product.id);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.productName,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '\Rp. ${product.productPrice}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                );
              }),
            ),
    );
  }
}
