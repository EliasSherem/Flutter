import 'package:fume/Config/config.dart';
import 'package:fume/Store/cart.dart';
import 'package:fume/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
      ),
      centerTitle: true,
      title: Text(
        "fume",
        style: TextStyle(
            fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.blue),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => CartPage());
                Navigator.pushReplacement(context, route);
              },
            ),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 3.0,
              bottom: 4.0,
              left: 5.0,
              child: Consumer<CartItemCounter>(
                builder: (context, counter, _) {
                  return Text(
                    (EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userCartList)!
                                .length -
                            1)
                        .toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
