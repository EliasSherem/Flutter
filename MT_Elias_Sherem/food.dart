import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'operation.dart';
import 'declaracion.dart';

class food extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food"),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
    );
  }
}
