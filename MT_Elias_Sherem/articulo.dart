import 'package:flutter/material.dart';
import 'imagen.dart';
import 'descripcion.dart';

class articulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[imagen(), descripcion()],
    )));
  }
}
