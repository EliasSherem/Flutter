import 'package:fume/Models/item.dart';
import 'package:fume/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  late Future<QuerySnapshot> docList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            searchWidget(),
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
                    itemCount: snap.data!.documents.length,
                    itemBuilder: (context, index) {
                      ItemModel model =
                          ItemModel.fromJson(snap.data!.documents[index].data);
                      return sourceInfo(model, context,
                          background: Colors.white);
                    },
                  )
                : Text("No data available");
          },
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value) {
                    startSearching(value);
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "Search here"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async {
    docList = Firestore.instance
        .collection("Items")
        .where("shortInfo", isGreaterThanOrEqualTo: query)
        .getDocuments();
  }
}
