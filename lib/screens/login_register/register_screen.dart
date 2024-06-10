import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/model/model_otp_send.dart';
import 'package:app_ecommerce/model/model_register.dart';
import 'package:app_ecommerce/screens/login_register/login_screen.dart';
import 'package:app_ecommerce/screens/login_register/verification_screen.dart';
import 'package:app_ecommerce/utils/cek_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isPasswordVisible = false;
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<ModelRegister?> registerAccount() async {
    try {
      if (!mounted) return null;
      setState(() {
        isLoading = true;
      });

      http.Response res =
          await http.post(Uri.parse('$url/register.php'), body: {
        "username": _usernameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "address": _addressController.text,
      });

      if (!mounted) return null;
      ModelRegister data = modelRegisterFromJson(res.body);
      if (data.value == 1) {
        if (!mounted) return null;
        setState(() {
          isLoading = false;
        });
        session.saveSession(data.value ?? 0, data.username ?? "",
            data.email ?? "", data.address ?? "", data.status ?? "");
        OTPsend();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => VerificationScreen()),
            (route) => false);
      } else {
        if (!mounted) return null;
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${data.message}')));
      }
    } catch (e) {
      if (!mounted) return null;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
  }

  Future<ModelOtpSend?> OTPsend() async {
    try {
      if (!mounted) return null;
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/otp_send.php'),
          body: {"email": _emailController.text});

      if (!mounted) return null;
      ModelOtpSend data = modelOtpSendFromJson(res.body);
      if (data.value == 1) {
        if (!mounted) return null;
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Code OTP dikirim ke email anda')));
      } else {
        if (!mounted) return null;
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${data.message}')));
      }
    } catch (e) {
      if (!mounted) return null;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 60),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Start learning with create your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Username",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: 'Create your username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
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
                  "Your Address",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.home_outlined),
                    labelText: 'Enter your address',
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
                    labelText: 'Create your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      registerAccount();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFEB3C3C),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Create Account',
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    icon: Image.asset(
                      "images/google.png",
                      width: 20,
                      height: 20,
                    ),
                    label: Text(
                      'Login',
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
                      // Handle Facebook sign up logic here
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
      ),
    );
  }
}
