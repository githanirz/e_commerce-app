import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/main.dart';
import 'package:app_ecommerce/model/model_editprofile.dart';
import 'package:app_ecommerce/utils/cek_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PageEditProfile extends StatefulWidget {
  const PageEditProfile({Key? key}) : super(key: key);

  @override
  State<PageEditProfile> createState() => _PageEditProfileState();
}

class _PageEditProfileState extends State<PageEditProfile> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtEmail = TextEditingController(); // Tambahkan ini
  TextEditingController txtAddress = TextEditingController(); // dan ini
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;
  String? id, username, email, address;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id");
      username = pref.getString("username");
      txtUsername.text = username ?? '';
      email = pref.getString("email");
      txtEmail.text = email ?? '';
      address = pref.getString("address");
      txtAddress.text = address ?? '';
    });
  }

  Future<ModelEditProfile?> updateProfile({
    String? newUsername,
    String? newEmail,
    String? newAddress,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });

      Map<String, String> requestBody = {
        "id": id!,
      };

      if (newUsername != null) {
        requestBody["username"] = newUsername;
        await session.updateUsername(
            newUsername); // Perbarui username di SharedPreferences
      }

      if (newEmail != null) {
        requestBody["email"] = newEmail;
        await session
            .updateEmail(newEmail); // Perbarui email di SharedPreferences
      }

      if (newAddress != null) {
        requestBody["address"] = newAddress;
        await session
            .updateAddress(newAddress); // Perbarui alamat di SharedPreferences
      }

      final response = await http.post(
        Uri.parse('$url/editprofile.php'),
        body: requestBody,
      );

      ModelEditProfile data = modelEditProfileFromJson(response.body);

      if (data.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${data.message}'),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(
                initialIndex:
                    3), // Ganti dengan nama halaman profileScreen Anda
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${data.message}'),
        ));
      }

      return data;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return null;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Form(
            key: keyForm,
            child: Column(
              children: [
                TextFormField(
                  controller: txtUsername,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Masukkan username baru",
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.blue.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: txtAddress,
                  validator: (val) {
                    // Validasi alamat di sini jika diperlukan
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Masukkan email baru",
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.blue.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: txtEmail,
                  validator: (val) {
                    // Validasi email di sini jika diperlukan
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Alamat",
                    hintText: "Masukkan alamat baru",
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.blue.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (keyForm.currentState?.validate() == true) {
                      final newUsername = txtUsername.text.trim();
                      final newEmail = txtEmail.text.trim();
                      final newAddress = txtAddress.text.trim();
                      updateProfile(
                        newUsername: newUsername,
                        newEmail: newEmail,
                        newAddress: newAddress,
                      ); // Panggil fungsi updateProfile
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Silakan isi data terlebih dahulu"),
                      ));
                    }
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  height: 50,
                  minWidth: double
                      .infinity, // Memperpanjang tombol hingga lebar maksimal
                  shape: RoundedRectangleBorder(
                    // Mengubah bentuk tombol menjadi rounded rectangle
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("Save Changes"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
