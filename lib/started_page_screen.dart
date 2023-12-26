import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hacakthon/utils/utils.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import 'models/login_detail.dart';
import 'otp_verification_screen.dart';

// import 'home_page.dart';

class StartedPageScreen extends StatefulWidget {
  const StartedPageScreen({super.key});

  @override
  State<StartedPageScreen> createState() => _StartedPageScreenState();
}

class _StartedPageScreenState extends State<StartedPageScreen> {
  final TextEditingController phoneController = TextEditingController();
  LoginDetail loginDetail = LoginDetail(
      phoneNumber: '',
      Name: '',
      aboutYourself: '',
      pronoun: '',
      livingIn: '',
      livingSince: 0,
      userPic: null,
      uid: '');
  String countryCode = '+91';
  String verify = "";
  TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Image(
            //   image: NetworkImage(
            //       'https://blog.localeyes.in/wp-content/uploads/2023/01/localeyes-removebg-preview-1.png'),
            //   width: 200,
            //   height: MediaQuery.of(context).size.height * 0.2,
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width,
            ),
            Text(
              'Let\'s Get Started',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Local for Vocal.....',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: IntlPhoneField(
                initialCountryCode: 'IN',
                onCountryChanged: (value) {
                  countryCode = value.dialCode;
                  setState(() {});
                },
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 5, 39, 67),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: phoneController.text.length == 10
                    ? () async {
                        print(countryCode + phoneController.text);
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: countryCode + phoneController.text,
                          verificationCompleted:
                              (PhoneAuthCredential credential) {
                            pinController.setText(credential.smsCode!);
                            log(900);
                            print(credential.smsCode!);
                          },
                          verificationFailed: (FirebaseAuthException e) {},
                          codeSent: (String verificationId, int? resendToken) {
                            verify = verificationId;
                            loginDetail.phoneNumber =
                                countryCode + phoneController.text;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OtpVerificationScreen(
                                      verify: verify,
                                      phone: phoneController.text,
                                      pinController: pinController,
                                      loginDetail: loginDetail,
                                    )));
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      }
                    : () {
                        showSnackBar('Enter a valid phone number', context);
                      },
                child: Text('Send Code ',
                    style: TextStyle(color: Color(0xff62c9d5))))
          ],
        ),
      )),
    );
  }
}
