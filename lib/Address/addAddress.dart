// ignore_for_file: file_names

import 'package:fume/Config/config.dart';
import 'package:fume/Store/storehome.dart';
import 'package:fume/Widgets/customAppBar.dart';
import 'package:fume/Models/address.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _cName = TextEditingController();
  final _cPhoneNumber = TextEditingController();
  final _cFlatHomeNumber = TextEditingController();
  final _cCity = TextEditingController();
  final _cState = TextEditingController();
  final _cPinCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            if(formKey.currentState!.validate()){
              final model = AddressModel(
                name: _cName.text.trim(),
                state: _cState.text.trim(),
                pincode: _cPinCode.text,
                phoneNumber: _cPhoneNumber.text,
                flatNumber: _cState.text,
                city: _cCity.text.trim(),
              ).toJson();
              //add to firestore
              EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.subCollectionAddress).document(DateTime.now().microsecondsSinceEpoch.toString()).setData(model).then((value) {
                  final snack =SnackBar(content: Text("New Address added succesfully"));
                  scaffoldKey.currentState!.showSnackBar(snack);
                  FocusScope.of(context).requestFocus(FocusNode());
                  formKey.currentState!.reset();
              });
              Route route = MaterialPageRoute(builder: (c)=> StoreHome() );
              Navigator.pushReplacement(context, route);
            }
            },
          label: Text("Done"),
          backgroundColor: Colors.blue,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Add New Address", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(key: formKey, hint: "Name", controller: _cName),
                    MyTextField(key: formKey, hint: "Phone Number", controller: _cPhoneNumber),
                    MyTextField(key: formKey, hint: "Flat number / House number", controller: _cFlatHomeNumber),
                    MyTextField(key: formKey, hint: "City", controller: _cCity),
                    MyTextField(key: formKey, hint: "State", controller: _cState),
                    MyTextField(key: formKey, hint: "Pin Code", controller: _cPinCode),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  MyTextField({required Key key, required this.hint,required this.controller}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val)=>val!.isEmpty ? "Field can not be empty" : null,
      ),
    );
  }
}
