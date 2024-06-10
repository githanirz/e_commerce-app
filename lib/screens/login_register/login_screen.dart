import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/main.dart';
import 'package:app_ecommerce/model/model_forgetpass.dart';
import 'package:app_ecommerce/model/model_login.dart';
import 'package:app_ecommerce/screens/home/home_screen.dart';
import 'package:app_ecommerce/utils/cek_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? id, username, email, address, password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotPassController = TextEditingController();

  bool _isPasswordVisible = false;

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;

  Future<ModelLogin?> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/login.php'), body: {
        "password": _passwordController.text,
        "email": _emailController.text
      });
      ModelLogin data = modelLoginFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value ,1 (ada data login),dan 0 (gagal)
      if (data.value == 1) {
        setState(() {
          //save session
          session.saveSession(
            data.value ?? 0,
            data.id ?? "",
            data.username ?? "",
            data.address ?? "",
            data.email ?? "",
          );

          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));

          //pindah ke page berita
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavBar()),
              (route) => false);
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Password anda salah')));
        });
      }
    } catch (e) {
      //munculkan error
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Password anda salah')));
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _forgotPassController.dispose();
    super.dispose();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id");
      username = pref.getString("username");
      email = pref.getString("email");
      address = pref.getString("address");
      password = pref.getString("password");
      print(id);
      print(username);
      print(email);
      print(address);
    });
  }

  Future<ModelForgetPass?> forgetpass() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res =
          await http.post(Uri.parse('$url/forgetpass.php'), body: {
        "email": _forgotPassController.text, // Use the captured input for email
        "new_password":
            _passwordController.text, // Use the captured input for new password
      });
      ModelForgetPass data = modelForgetPassFromJson(res.body);
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Password successfully changed')));
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  void _showForgotPasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Forgot password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Enter your email and new password',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 50),
                  TextField(
                    controller: _forgotPassController, // Capture email here
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      labelText: 'Email or Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller:
                        _passwordController, // Capture new password here
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      forgetpass(); // Call forgetpass method
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 20, horizontal: 80), // Adjust padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      primary: Color(0xFFEB3C3C),
                    ),
                    child: Text(
                      'Change Password',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 60),
              Text(
                'Login Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please login with registered account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Email or Phone Number",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: 'Enter your email or phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Password",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  labelText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 8), // Add spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _showForgotPasswordModal(context);
                    },
                    child: Text(
                      'Forgot your password?',
                      style: TextStyle(
                        color: Color(0xFF5E60CE),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => HomeScreen()));
                    loginAccount();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFEB3C3C),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Or using other method',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  icon: Image.asset(
                    "images/google.png",
                    width: 20,
                    height: 20,
                  ),
                  label: Text(
                    'Sign Up with Google',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  icon: Icon(Icons.facebook, color: Colors.blue),
                  label: Text(
                    'Sign Up with Facebook',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
