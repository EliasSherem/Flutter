import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fume/Widgets/customTextField.dart';
import 'package:fume/DialogBox/errorDialog.dart';
import 'package:fume/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:fume/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cpasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImagUrl = "";
  File _imageFile = File("");
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _cpasswordTextEditingController,
                    data: Icons.lock,
                    hintText: "Confirm Passwod",
                    isObsecure: false,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                uploadAndSaveImage();
              },
              child: Text(
                "Sign up",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.blue,
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == "") {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              key: _formkey,
              message: "Please select an image",
            );
          });
    } else {
      _passwordTextEditingController.text ==
              _cpasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _cpasswordTextEditingController.text.isNotEmpty &&
                  _nameTextEditingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog("Please fill up the complete form")
          : displayDialog("Password does not match");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(key: _formkey, message: msg);
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            key: _formkey,
            message: "Registering user, please wait...",
          );
        });
    String imageFilename = DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFilename);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImagUrl = urlImage;
      _regiterUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _regiterUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
                key: _formkey, message: error.message.toString());
          });
    });
    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser fUser) async {
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImagUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userUID, fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameTextEditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImagUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}
