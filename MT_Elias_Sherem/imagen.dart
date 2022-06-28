import 'package:flutter/material.dart';

class imagen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.network(
            "https://www.welivesecurity.com/wp-content/uploads/es-la/2012/12/Logo-Android.png"));
  }
}
