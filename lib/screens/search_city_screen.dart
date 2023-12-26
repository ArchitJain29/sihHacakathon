import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../methods/location_controller.dart';
import '../utils/global_variable.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../providers/global.dart';

class SearchCityScreen extends StatefulWidget {
  Function() callBack;
  SearchCityScreen({super.key, required this.callBack});

  @override
  State<SearchCityScreen> createState() => _SearchCityScreenState();
}

class _SearchCityScreenState extends State<SearchCityScreen> {
  String selectedCity = "";
  LocationController _locationController = LocationController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationController.getCityList().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Search your city',
          style: TextStyle(color: Color(0xff62c9d5)),
        ),
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              height: 70,
              child: TextFormField(
                onChanged: (value) {
                  selectedCity = value;
                  log(selectedCity);
                  setState(() {});
                },
                decoration: InputDecoration(
                  prefix: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                  hintText: 'eg Jaipur',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                itemCount: cityList['city']!.length,
                itemBuilder: (builder, index) {
                  // return ListTile(
                  //   title: Text(cityList['city']![index]),
                  // );
                  if (cityList['city']![index]
                          .toLowerCase()
                          .contains(selectedCity.toLowerCase()) ||
                      selectedCity == '') {
                    return ListTile(
                      // leading: CachedNetworkImage(
                      //   imageUrl: cityList['cityImage']![index],
                      //   imageBuilder: (context, imageProvider) => CircleAvatar(
                      //     backgroundImage: imageProvider,
                      //     radius: 18,
                      //   ),
                      // ),
                      onTap: () async {
                        final global =
                            Provider.of<Global>(context, listen: false);
                        global.userPlace = cityList['city']![index];
                        global.selectedCity = cityList['city']![index];
                        log(cityList['city']![index]);
                        isSelectedCityPostFetching = true;
                        Navigator.of(context).pop(true);
                      },
                      title: Text(cityList['city']![index]),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
