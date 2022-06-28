import 'package:flutter/material.dart';
import 'contacto.dart';
import 'MainPage.dart';
import 'acerca.dart';
import 'food.dart';

class tabsG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.info)),
                Tab(icon: Icon(Icons.web)),
                Tab(icon: Icon(Icons.contact_phone)),
                Tab(icon: Icon(Icons.fastfood)),

                //Tab(icon: Icon(Icons.email)),
              ],
            ),
            title: Text('Practica 2'),
            backgroundColor: Colors.blue,
          ),
          body: TabBarView(
            children: [
              acerca(),
              MainPage(),
              contacto(),
              food(),
            ],
          ),
        ),
      ),
    );
  }
}
