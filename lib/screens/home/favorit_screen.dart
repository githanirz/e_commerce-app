import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../const.dart';
import '../../model/model_favorit.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String? username, id;
  Future<List<Datum>?>? _futureProduct;
  List<Datum> _productData = [];
  List<Datum> _searchResult = [];
  final TextEditingController _searchController = TextEditingController();

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
      _futureProduct = getFavoriteProducts();
    });
  }

  Future<void> removeFavorite(String productId) async {
    final response = await http.post(
      Uri.parse('$url/deletefavorite.php'),
      body: {
        'id_product': productId,
        'id_user': id,
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['isSuccess']) {
        setState(() {
          _productData.removeWhere((product) => product.productId == productId);
          _searchResult
              .removeWhere((product) => product.productId == productId);
        });
        print('Item favorite berhasil dihapus');
      } else {
        print('Gagal menghapus item favorite: ${result['message']}');
      }
    } else {
      print('Server error: ${response.statusCode}');
    }
  }

  Future<List<Datum>?> getFavoriteProducts() async {
    try {
      http.Response res =
          await http.get(Uri.parse('$url/listfavorite.php?id_user=$id'));
      if (res.statusCode == 200) {
        return modelListFavoriteFromJson(res.body).data;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to load data")));
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  void _filterSearchResults(String query) {
    List<Datum> searchResults = [];
    if (query.isNotEmpty) {
      _productData.forEach((datum) {
        if (datum.productName.toLowerCase().contains(query.toLowerCase())) {
          searchResults.add(datum);
        }
      });
    }
    setState(() {
      _searchResult = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 60), // Add space from the top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'My Favorite',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center, // Align text to the center
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Container(
              width: 400,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterSearchResults,
                decoration: InputDecoration(
                  hintText: 'Search Something',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      // Define action for filter button here
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Datum>?>(
              future: _futureProduct,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No favorite products found"));
                } else {
                  _productData = snapshot.data!;
                  return CustomScrollView(
                    slivers: [
                      SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 260,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          Datum data = _searchResult.isNotEmpty
                              ? _searchResult[index]
                              : _productData[index];
                          return InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         DetailProductScreen(product: data),
                              //   ),
                              // );
                            },
                            child: Padding( // Add Padding widget here
                              padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust the padding as needed
                              child: Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.0),
                                            topRight: Radius.circular(16.0),
                                          ),
                                          child: Image.network(
                                            '$url/gambar/${data.productImage}',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 180,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "${data.productName}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                '\Rp.${data.productPrice}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          removeFavorite(data.productId);
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: _searchResult.isNotEmpty
                            ? _searchResult.length
                            : _productData.length,
                      ),
                    ),

                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
