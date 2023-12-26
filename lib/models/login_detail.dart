import 'dart:ffi';

import 'package:flutter/foundation.dart';

class LoginDetail {
  String phoneNumber;
  String Name;
  String aboutYourself;
  String pronoun;
  String livingIn;
  int livingSince;
  Uint8List? userPic;
  String uid;
  LoginDetail(
      {required this.phoneNumber,
      required this.Name,
      required this.aboutYourself,
      required this.pronoun,
      required this.livingIn,
      required this.livingSince,
      required this.userPic,
      required this.uid});
}
