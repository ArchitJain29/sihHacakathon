import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hacakthon/started_page_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    print('1');
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/i1.png',
            width: deviceSize.width,
            height: deviceSize.height / 0.9,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-0.1 * pi / 180)
                        ..translate(-5.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 12, 64, 70),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'TradeMate',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: const Color(0xff62c9d5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StartedPageScreen()));
                      },
                      child: Text('Login With Phone Number',
                          style: TextStyle(color: Colors.black, fontSize: 15))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  // const AuthCard({
  //   Key key,
  // }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  Uint8List? _file;
  final _passwordController = TextEditingController();
  AnimationController? _controller;
  Animation<Size>? _heightAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;
  static const List<String> list = <String>['user', 'seller'];
  String dropdownValue = list.first;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.5), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));

    _opacityAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));
    // _heightAnimation!.addListener(() => setState(() {}));
    super.initState();
  }

  pickImage(ImageSource source) async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return _file.readAsBytes();
    }
    print("No image selected");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  void _showError(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signUp(
            _authData['email']!,
            _authData['password']!,
            _authData['username']!,
            _authData['phone']!,
            dropdownValue);
        // print(_authData.toString());
      }
    } on HttpExceptions catch (error) {
      var errorMessage = 'Authentication Failed!';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This Email Address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that mail';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showError(errorMessage);
    } catch (error) {
      print(error);
      const errorMessage = 'Could not Authenticate you,please try again later.';
      _showError(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedBuilder(
        animation: _heightAnimation!,
        builder: (context, ch) => Container(
          // height: _authMode == AuthMode.Signup ? 320 : 260,
          height: _heightAnimation!.value.height,
          constraints:
              BoxConstraints(minHeight: _heightAnimation!.value.height),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16.0),
          child: ch,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _file == null
                    ? CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            AssetImage('assets/images/im.png'), // child: ,
                      )
                    : CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: MemoryImage(_file!), // child: ,
                      ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  onChanged: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                // if (_authMode == AuthMode.Signup)

                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 150 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 400 : 0),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            enabled: _authMode == AuthMode.Signup,
                            decoration:
                                InputDecoration(labelText: 'Confirm Password'),
                            obscureText: true,
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match!';
                                    }
                                  }
                                : null,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Username'),
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              _authData['username'] = value!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Phone Number'),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              _authData['phone'] = value!;
                            },
                          ),
                          Container(
                            width: deviceSize.width * 0.7,
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                // border: Border.all(),
                                ),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              // icon: const Icon(Icons.arrow_downward),
                              // elevation: 12,
                              style: const TextStyle(color: Colors.black),
                              // underline: Container(
                              //   height: 2,
                              //   color: Color.fromARGB(255, 223, 222, 222),
                              // ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(30),
                    // ),
                    // padding:
                    //     EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    // color: Theme.of(context).primaryColor,
                    // textColor: Theme.of(context).primaryTextTheme.button!.color,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff62c9d5)),
                    ),
                    child: Text(
                      _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _switchAuthMode,
                  // padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // textColor: Theme.of(context).primaryColor

                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 30, vertical: 4)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                    style: TextStyle(color: Color(0xff62c9d5)),
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
