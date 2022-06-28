import 'package:flutter/foundation.dart';
import 'package:fume/Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList)!.length-1;
  int get count => _counter;
  Future<void>displayResult()async{
    int _counter = EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList)!.length-1;
    await Future.delayed(const Duration(microseconds: 100),(){
      notifyListeners();
    });
  }
}
