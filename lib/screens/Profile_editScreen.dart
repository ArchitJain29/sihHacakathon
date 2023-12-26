import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hacakthon/screens/products_overview_screen.dart';
import 'package:hacakthon/screens/search_city_screen.dart';
import 'package:hacakthon/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/text_input_field.dart';

class ProfileEditSceen extends StatefulWidget {
  // final snapshot;

  // const ProfileEditSceen({super.key, required this.snapshot});

  @override
  State<ProfileEditSceen> createState() => _ProfileEditSceenState();
}

class _ProfileEditSceenState extends State<ProfileEditSceen> {
  Uint8List? _file;
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _livingController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  pickImage(ImageSource source) async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return _file.readAsBytes();
    }
    print("No image selected");
  }

  onPopBack() {
    setState(() {});
  }

  // @override
  // void initState() {
  //   _usernameController.text = widget.snapshot.data.docs[0]['fullname'];
  //   _locationController.text = widget.snapshot.data.docs[0]['locality'];
  //   _emailController.text = widget.snapshot.data.docs[0]['email'];
  //   _livingController.text =
  //       widget.snapshot.data.docs[0]['living_since'].toString();
  //   _phoneController.text = widget.snapshot.data.docs[0]['phoneNum'].toString();
  //   _bioController.text = widget.snapshot.data.docs[0]['bio'].toString();
  //   // gender =
  //   super.initState();
  // }

  int gender = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 50),
                child: avatar()),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextInputField(
                controller: _usernameController,
                labelText: 'Username',
                icon: Icons.person,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextInputField(
                controller: _bioController,
                labelText: 'Write Something about Yourself',
                icon: Icons.person,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextInputField(
                enabled: true,
                controller: _emailController,
                labelText: 'E-mail',
                icon: Icons.mail,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'I am',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    gender = 1;
                    setState(() {});
                  },
                  child: Card(
                    elevation: 4,
                    child: Container(
                      width: 150,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: gender == 1
                            ? Colors.greenAccent
                            : Colors.transparent,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_business_outlined,
                              color: gender == 1 ? Colors.white : Colors.black,
                            ),
                            Text(
                              ' Seller',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color:
                                      gender == 1 ? Colors.white : Colors.grey,
                                  fontSize: 16),
                            )
                          ]),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    gender = 2;
                    setState(() {});
                  },
                  child: Card(
                    elevation: 4,
                    child: Container(
                      width: 150,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: gender == 2
                            ? Colors.greenAccent
                            : Colors.transparent,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_task,
                              color: gender == 2 ? Colors.white : Colors.black,
                            ),
                            Text(
                              ' Buyer',
                              style: TextStyle(
                                  color:
                                      gender == 2 ? Colors.white : Colors.grey,
                                  fontSize: 16),
                            )
                          ]),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextInputField(
                controller: _livingController,
                labelText: 'Living Since',
                icon: Icons.location_on,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   margin: const EdgeInsets.only(left: 20, right: 20),
            //   child: TextInputField(
            //     enabled: false,
            //     controller: _phoneController,
            //     labelText: 'Contact No.',
            //     icon: Icons.phone,
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextInputField(
                controller: _locationController,
                labelText: 'Locality',
                icon: Icons.location_city,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                // await FirestoreMethods().updateProfile(
                //     _file!,
                //     _bioController.text,
                //     _usernameController.text,
                //     int.parse(_livingController.text),
                //     _locationController.text);
                Navigator.of(context).pop();
              },
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      backgroundColor: const Color(0xff62c9d5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onPressed: () async {
                    if (_usernameController.text == null) {
                      showSnackBar('Fil The Username', context);
                    }
                    if (_emailController.text == null) {
                      showSnackBar('Fil The E-mail Address', context);
                    }
                    if (_file == null) {
                      showSnackBar('Select a Profile photo', context);
                    }
                    if (_livingController.text == null) {
                      showSnackBar('Fil The Detail Required', context);
                    }
                    if (_locationController.text == null) {
                      showSnackBar('Fil The Detail Required', context);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProductsOverviewScreen()));
                    }
                  },
                  child: Text('One Step Closer',
                      style: TextStyle(color: Colors.black, fontSize: 15))),
            )
          ],
        ),
      ),
    );
  }

  Widget avatar() {
    return Stack(
      children: [
        _file == null
            ? CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    'https://www.goodmorningimagesdownload.com/wp-content/uploads/2021/12/Best-Quality-Profile-Images-Pic-Download-2023.jpg'), // child: ,
              )
            : CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                backgroundImage: MemoryImage(_file!), // child: ,
              ),
        Positioned(
            bottom: 0,
            left: 120,
            child: IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () async {
                final pickedImage = await pickImage(ImageSource.gallery);
                if (pickedImage != null) {
                  _file = pickedImage;
                  setState(() {});
                }
              },
            ))
      ],
    );
  }
}

// late Rx<File?> _pickedImage;

//   File? get profilePhoto => _pickedImage.value;
//   void pickImage() async {
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       Get.snackbar('Profile Picture', 'You have succesfully set profile image');
//     }
//     {
//       _pickedImage = Rx<File?>(File(pickedImage!.path));
//     }
//   }
