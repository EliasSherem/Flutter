import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'dart:io';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class contacto extends StatefulWidget {
  @override
  _contactoState createState() => _contactoState();
}

class _contactoState extends State<contacto> {
  hacerllamada() async {
    const url = 'tel:+525611732425';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'error al llamar la $url';
    }
  }

  enviarsms(String msj, List<String> d) async {
    String r = await sendSMS(message: msj, recipients: d).catchError((onError) {
      print(onError);
    });
    print(r);
  }

  openwhatsapp(String message, String destinatario) async {
    final link = WhatsAppUnilink(
      phoneNumber: destinatario,
      text: message,
    );
    await launch('$link');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text('contacto')),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(25),
                width: 100,
                child: TextButton(
                  child: Text('llamada', style: TextStyle(fontSize: 20.0)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                  onPressed: hacerllamada,
                )),
            Container(
                margin: EdgeInsets.all(25),
                width: 100,
                child: TextButton(
                  child: Text('SMS', style: TextStyle(fontSize: 20.0)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                  onPressed: () {
                    String msj = 'demo';
                    List<String> d = ['+525611732425', '+525651232'];
                    enviarsms(msj, d);
                  },
                )),
            Container(
                margin: EdgeInsets.all(25),
                width: 100,
                child: TextButton(
                  child: Text('Whatsapp', style: TextStyle(fontSize: 20.0)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                  onPressed: () {
                    String mensaje = "Esto es un mensaje";
                    String destinatario = "+525611732425";
                    openwhatsapp(mensaje, destinatario);
                  },
                ))
          ],
        ),
      ),
    ));
  }
}
