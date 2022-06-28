import 'package:flutter/material.dart';
import 'articulo.dart';

class acerca extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'descripcion',
        home: Scaffold(
          appBar: AppBar(title: Text('descrpicion')),
          body: articulo(),
        ));
  }
}
