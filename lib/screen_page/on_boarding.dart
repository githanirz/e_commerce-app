import 'package:app_ecommerce/screens/login_register/login_screen.dart';
import 'package:app_ecommerce/screens/login_register/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
class OnBoardingScreen extends StatelessWidget {
  final Color redshoes = const Color(0xFFEB3C3C);

  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Register',
      onFinish: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const RegisterScreen(),
          ),
        );
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: redshoes,
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: redshoes,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          color: redshoes,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
      controllerColor: redshoes,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: [
        Center(
          child: Image.asset(
            'images/img1.png',
            height: 400,
            width: 420,
          ),
        ),
        Center(
          child: Image.asset(
            'images/img2.png',
            height: 400,
            width: 420,
          ),
        ),
        Center(
          child: Image.asset(
            'images/img3.png',
            height: 400,
            width: 420,
          ),
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Various Collections Of The Latest Products',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: redshoes,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Discover the latest fashion collections, exclusive shoes, and trendy sneakers ready to complement your style',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Complete Collections Of Colors And Sizes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: redshoes,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Enjoy an easy and enjoyable shopping experience with our advanced features',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Find The Most Suitable \nOutfit For You',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: redshoes,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Dont miss the special offers and attractive promos that we have prepared especially for you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
