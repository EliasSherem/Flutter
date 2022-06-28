// ignore: file_names
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fume/Admin/adminShiftOrders.dart';
import 'package:fume/Widgets/loadingWidget.dart';
import 'package:fume/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File? file = null;
  TextEditingController _descriptiontextEditingController =
      TextEditingController();
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _shortInfotextEditingController =
      TextEditingController();
  String productId = DateTime.now().millisecond.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null
        ? displayAdminHomeSceen()
        : displayAdminUploadFromScreen();
  }

  displayAdminHomeSceen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                child: Text(
                  "Add new items",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.lightBlueAccent,
                onPressed: () => takeImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Item Image",
              style: TextStyle(
                  color: Colors.lightBlueAccent, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture with camera",
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select from gallery",
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      file = imageFile;
    });
  }

  pickPhotoFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageFile;
    });
  }

  displayAdminUploadFromScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: clearFormInfo,
        ),
        title: Text(
          "New product",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          FlatButton(
            child: Text(
              "Add",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file!), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.blue),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfotextEditingController,
                decoration: InputDecoration(
                  hintText: "Short info",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.blue),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titletextEditingController,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.blue),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptiontextEditingController,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.blue),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _pricetextEditingController,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = "" as File;
      _descriptiontextEditingController.clear();
      _pricetextEditingController.clear();
      _shortInfotextEditingController.clear();
      _titletextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFile) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask =
        storageReference.child("product_$productId.jpg").putFile(mFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadurl = await taskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef = Firestore.instance.collection("Items");
    itemsRef.document(productId).setData({
      "shortInfo": _shortInfotextEditingController.text.trim(),
      "longDescription": _descriptiontextEditingController.text.trim(),
      "price": int.parse(_pricetextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titletextEditingController.text.trim(),
    });
    setState(() {
      file = "" as File;
      uploading = false;
      productId = DateTime.now().millisecond.toString();
      _descriptiontextEditingController.clear();
      _titletextEditingController.clear();
      _shortInfotextEditingController.clear();
      _pricetextEditingController.clear();
    });
  }
}
