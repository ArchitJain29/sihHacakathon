import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // Future.delayed(Duration(seconds: 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: Container(
        width: deviceSize.width,
        height: deviceSize.height,
        child: Image.asset(
          'assets/images/splashscreen.png',
          fit: BoxFit.cover,
        ),
      )),
    );
  }
}
