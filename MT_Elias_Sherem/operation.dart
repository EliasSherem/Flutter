import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'declaracion.dart';

Future<List<Declaracion>> fetchDeclaracion() async {
  final response = await http.get('https://foodish-api.herokuapp.com/');
  if (response.statusCode == 200) {
    return decodeRespuesta(response.body);
  } else {
    throw Exception('Unable to fetch data');
  }
}

List<Declaracion> decodeRespuesta(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<Declaracion>((json) => Declaracion.fromMap(json)).toList();
}
