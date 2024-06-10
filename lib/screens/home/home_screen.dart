import 'package:app_ecommerce/main.dart';
import 'package:app_ecommerce/model/model_insertfav.dart';
import 'package:app_ecommerce/model/model_product.dart';
import 'package:app_ecommerce/screens/category/category_casual.dart';
import 'package:app_ecommerce/screens/category/category_sneaker.dart';
import 'package:app_ecommerce/screens/category/category_sport.dart';
import 'package:app_ecommerce/screens/category/category_wanita.dart';
import 'package:app_ecommerce/screens/home/list_all_scren.dart';
import 'package:app_ecommerce/screens/my_cart/order_tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_ecommerce/const.dart';
import 'package:http/http.dart' as http;
import 'detail_product_screen.dart'; // Import the DetailProductScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username, id;
  late CarouselController _carouselController;
  int _selectedCategory =
      0; // Menambahkan variabel untuk menyimpan kategori yang dipilih
  Set<String> favoriteProductIds = {};

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
      id = pref.getString("id") ?? '';
      print('id $id');
    });
  }

  void goToPreviousSlide() {
    _carouselController.previousPage();
  }

  void goToNextSlide() {
    _carouselController.nextPage();
  }

  Future<List<Datum>?> getProduct() async {
    try {
      http.Response res = await http.get(Uri.parse('$url/listproduct.php'));
      return modelProductFromJson(res.body).data;
    } catch (e) {
      setState(() {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(e.toString())));
      });
      return null;
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
          content: Text("item dimasukkan difavorite"),
          backgroundColor: Colors.green,
        ));

        // Perbarui status favorit
        setState(() {
          favoriteProductIds.add(productId);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BottomNavBar(initialIndex: 2),
          ));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("item sudah ada difavorite : ${data.message}"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("item sudah ada difavorite"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    getSession();
    getProduct();
    _carouselController = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Image.asset(
                  'images/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi, ${username ?? 'User'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderTrackingScreen()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.history), // Icon untuk riwayat
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(products: products)));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 20), // Add some space between the text and the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory =
                              0; // Mengatur kategori yang dipilih menjadi 0 (misalnya, "Home")
                        });
                      },
                      child: Text(
                        'Home',
                        style: TextStyle(
                            color: _selectedCategory == 0
                                ? Color(0xFFEB3C3C)
                                : Colors.black),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 50,
                      color: _selectedCategory == 0
                          ? Color(0xFFEB3C3C)
                          : Colors.transparent,
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory =
                              1; // Mengatur kategori yang dipilih menjadi 1 (misalnya, "Category")
                        });
                      },
                      child: Text(
                        'Category',
                        style: TextStyle(
                            color: _selectedCategory == 1
                                ? Color(0xFFEB3C3C)
                                : Colors.black),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 50,
                      color: _selectedCategory == 1
                          ? Color(0xFFEB3C3C)
                          : Colors.transparent,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
                height:
                    20), // Add some space between the buttons and the carousel
            if (_selectedCategory ==
                1) // Menampilkan banner jika kategori yang dipilih adalah "Category"
              Column(
                children: [
                  SizedBox(height: 20), // Berikan jarak antara banner
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategorySneaker()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Image.asset('images/banner1.png',
                          width: MediaQuery.of(context).size.width - 40),
                    ),
                  ),
                  SizedBox(height: 20), // Berikan jarak antara banner
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategorySport()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Image.asset('images/banner2.png',
                          width: MediaQuery.of(context).size.width - 40),
                    ),
                  ),
                  SizedBox(height: 20), // Berikan jarak antara banner
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryCasual()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Image.asset('images/banner3.png',
                          width: MediaQuery.of(context).size.width - 40),
                    ),
                  ),
                  SizedBox(height: 20), // Berikan jarak antara banner
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryWanita()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Image.asset('images/banner4.png',
                          width: MediaQuery.of(context).size.width - 40),
                    ),
                  ),
                  SizedBox(height: 20), // Berikan jarak antara banner
                ],
              ),
            if (_selectedCategory ==
                0) // Hanya tampilkan Carousel jika kategori yang dipilih adalah "Home"
              CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio:
                      36 / 16, // Sesuaikan dengan rasio aspek gambar Anda
                  onPageChanged: (index, reason) {
                    setState(() {
                      // Update the state if you need to do something on page change
                    });
                  },
                ),
                items: [
                  'images/slider1.png',
                  'images/slider2.jpg',
                  'images/slider3.jpg',
                  'images/slider4.jpg'
                ].map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            SizedBox(
                height:
                    20), // Add some space between the carousel and the new section
            if (_selectedCategory ==
                0) // Hanya tampilkan kategori "New Arrival" jika kategori yang dipilih adalah "Home"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Arrival',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListProductAll()));
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                            color:
                                Color(0xFFEB3C3C)), // Warna huruf di "See all"
                      ),
                    ),
                  ],
                ),
              ),
            // List of New Arrival Shoes
            if (_selectedCategory ==
                0) // Hanya tampilkan produk jika kategori yang dipilih adalah "Home"
              FutureBuilder<List<Datum>?>(
                future: getProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products available.'));
                  } else {
                    List<Datum> products = snapshot.data!
                        .take(2)
                        .toList(); // Display only the first 2 products
                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                      children: List.generate(products.length, (index) {
                        Datum product = products[index];
                        bool isFavorite =
                            favoriteProductIds.contains(product.id);
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal:
                                  10.0), // Tambah jarak vertikal di sini
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailProductScreen(product: product),
                                ),
                              );
                            },
                            child: Card(
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
                                          height: 135.0,
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFavorite
                                                ? Colors.red
                                                : Colors.grey,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productName,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                3), // Tambah jarak vertikal di sini
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
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
