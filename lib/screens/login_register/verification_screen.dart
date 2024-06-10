import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/model/model_verify.dart';
import 'package:app_ecommerce/screens/login_register/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController1 = TextEditingController();
  final TextEditingController _codeController2 = TextEditingController();
  final TextEditingController _codeController3 = TextEditingController();
  final TextEditingController _codeController4 = TextEditingController();
  String? email;
  String? address;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("username");
      address = pref.getString("address");
    });
  }

  Future<ModelVerify?> OTPverify() async {
    try {
      setState(() {
        isLoading = true;
      });
      print(email);
      http.Response res =
          await http.post(Uri.parse('$url/otp_verify.php'), body: {
        "email": email,
        "otp": (_codeController1.text +
            _codeController2.text +
            _codeController3.text +
            _codeController4.text)
      });

      ModelVerify data = modelVerifyFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value 2 (email sudah terdaftar),1 (berhasil),dan 0 (gagal)
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          _showSuccessDialog();
        });
      } else if (data.value == 2) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFEB3C3C),
                child: Icon(Icons.email, color: Colors.white, size: 40),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Verification Code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'We have sent the code verification to',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Center(
              child: Text(
                "$email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCodeInput(_codeController1),
                _buildCodeInput(_codeController2),
                _buildCodeInput(_codeController3),
                _buildCodeInput(_codeController4),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                print(_codeController1.text +
                    _codeController2.text +
                    _codeController3.text +
                    _codeController4.text);

                OTPverify();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Color(0xFFEB3C3C),
              ),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => LoginScreen(),
                child: Text(
                  "Resend OTP?",
                  style: TextStyle(color: Color(0xFFEB3C3C)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInput(TextEditingController controller) {
    return Container(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "images/checkverif.png",
                scale: 5,
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                'Verification Successful',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your email has been verified successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  primary: Color(0xFFEB3C3C),
                ),
                child: Text(
                  'Go to HomePage',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        );
      },
    );
  }
}
