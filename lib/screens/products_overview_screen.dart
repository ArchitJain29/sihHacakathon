import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hacakthon/methods/location_controller.dart';
import 'package:hacakthon/providers/global.dart' as glb;
import 'package:hacakthon/screens/teleport_screen.dart';
import 'package:provider/provider.dart';
import '/providers/products.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isloading = false;
  LocationController locationController = LocationController();
  String type = 'user';

  onPopBack() {
    setState(() {});
  }

  Future<String> check(String uid) async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String type = userData['type'];
    log(type.toString());
    return type;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isloading = true;
    });
    // String uid = FirebaseAuth.instance.currentUser!.uid;
    // log(uid);
    // check(uid).then((value) {
    //   locationController.getCurrentLocation(context).then((_) {
    //     if (value == 'seller') {
    //       type = 'seller';
    //     } else {
    //       type = 'user';
    //       Provider.of<Products>(context, listen: false).fetchAndGet().then((_) {
    //         setState(() {
    //           _isloading = false;
    //         });
    //       });
    //     }
    //   });
    // });

    locationController.getCurrentLocation(context).then((_) {
      Provider.of<Products>(context, listen: false).fetchAndGet().then((_) {
        setState(() {
          _isloading = false;
        });
      });
    });
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   if (_isInit) {

  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    glb.Global global = Provider.of<glb.Global>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Consumer<glb.Global>(
          builder: (context, value, ch) {
            return InkWell(
              onTap: () {
                value.setUserPlace(value.userLocality);
              },
              onDoubleTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => TeleportScreen(
                              callBack: onPopBack,
                            )))
                    .then((value) {
                  if (value) {
                    setState(() {});
                  }
                });
              },
              child: Text(
                value.userPlace,
                style: TextStyle(color: Colors.black),
              ),
            );
          },
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badges(
              child: ch!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isloading = true;
          });
          await Provider.of<Products>(context, listen: false)
              .fetchAndGet()
              .then((_) {
            setState(() {
              _isloading = false;
            });
          });
        },
        child: _isloading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff62c9d5),
                ),
              )
            : type == 'seller'
                ? const Center(
                    child: Text('seller'),
                  )
                : ProductsGrid(_showOnlyFavorites),
      ),
    );
  }
}
