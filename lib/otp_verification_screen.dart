import 'dart:developer';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hacakthon/screens/Profile_editScreen.dart';
import 'package:hacakthon/screens/edit_screen.dart';
import 'package:pinput/pinput.dart';
import 'models/login_detail.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verify;
  final String phone;
  TextEditingController pinController;
  LoginDetail loginDetail;
  OtpVerificationScreen(
      {super.key,
      required this.verify,
      required this.phone,
      required this.pinController,
      required this.loginDetail});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController phoneController = TextEditingController();
  TextEditingController smsController = TextEditingController();
  String smsCode = "";
  String countryCode = '+91';
  String verify = "";
  late String _otp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width,
            ),
            Text(
              'OTP Verification',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Image(
              image: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS55EGOVVE-CPiMvrdu8Ykb5udA9YSyQQC9fvgzm3hy3aUQpIvFwrABCKg3DUbiwRcsIU&usqp=CAU'),
              height: 300,
              width: 400,
            ),
            Text('Enter the 6-digit code sent to you at ${widget.phone}'),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: Pinput(
                senderPhoneNumber: phoneController.text,
                autofocus: true,
                length: 6,
                // autofillHints: [AutofillHints.oneTimeCode],
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                controller: widget.pinController,
                onChanged: (value) {
                  smsCode = value;
                },
                onSubmitted: (value) async {
                  try {
                    // log(smsCode);
                    log(smsController.text);
                    // log(verify);
                    // log(widget.verify + " hello");
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: widget.verify, smsCode: value);
                    await auth.signInWithCredential(credential);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileEditSceen()));

                    log("success");
                  } catch (e) {
                    log(e.toString());
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Invalid otp')));
                  }
                },
              ),

              // child: PinFieldAutoFill(
              //    strategy: SampleStrategy(),
              //   onCodeChanged: (code) {
              //     setState(() {
              //       _otp = code!;
              //     });
              //   },
              // ),

              // color: Colors.amber,
              // child: OtpPinField(

              //   maxLength: 6,
              //   onSubmit: (value) async {
              //     try {
              //       // log(smsCode);
              //       log(smsController.text);
              //       // log(verify);
              //       // log(widget.verify + " hello");
              //       PhoneAuthCredential credential =
              //           PhoneAuthProvider.credential(
              //               verificationId: widget.verify, smsCode: value);
              //       await auth.signInWithCredential(credential);
              //       Navigator.of(context).pushAndRemoveUntil(
              //           MaterialPageRoute(
              //               builder: (context) => SetProfileScreen()),
              //           ModalRoute.withName('/'));
              //       (SnackBar(content: Text('Success')));
              //       log("success");
              //     } catch (e) {
              //       log(e.toString());
              //       ScaffoldMessenger.of(context)
              //           .showSnackBar(SnackBar(content: Text('Invalid otp')));
              //     }
              //   },
              //   onChange: (value) {
              //     smsCode = value;
              //   },
              // ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: countryCode + phoneController.text,
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {
                    verify = verificationId;
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              },
              child: Text(
                'Resend OTP',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 5, 39, 67),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () async {
                  try {
                    log(smsCode);
                    log(smsController.text);
                    log(verify);
                    log(smsCode);
                    log(widget.verify + " hello");
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: widget.verify, smsCode: smsCode);
                    await auth.signInWithCredential(credential);
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(
                    //         builder: (context) => SetProfileScreen(
                    //               loginDetail: widget.loginDetail,
                    //             )),
                    //     ModalRoute.withName('/'));
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ProfileEditSceen();
                    }));
                    (SnackBar(content: Text('Success')));
                    log("success");
                  } catch (e) {
                    log(e.toString());
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Invalid otp')));
                  }
                },
                child:
                    Text('Verify', style: TextStyle(color: Color(0xff62c9d5))))
          ],
        ),
      ),
    ));
  }
}
