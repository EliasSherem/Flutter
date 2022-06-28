import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fume/Config/config.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors:[Colors.blue, Colors.lightBlueAccent],
                    begin: const FractionalOffset(0.0,0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0,1.0],
                    tileMode: TileMode.clamp
                )
            ),
          ),
          centerTitle: true,
          title: Text("My orders", style: TextStyle(color: Colors.white,),),
          actions: [
            IconButton(
                onPressed: (){
                  SystemNavigator.pop();
                },
                icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white,)
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
              .collection(EcommerceApp.collectionOrders).snapshots(),
          builder: (c,snapshot){
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.documents.length,
                    itemBuilder: (c,index){
                      return FutureBuilder<QuerySnapshot>(
                        future: Firestore.instance
                            .collection("Items")
                            .where("shortInfo",whereIn: snapshot.data!.documents[index].data[EcommerceApp.productID])
                            .getDocuments(),
                        builder: (c,snap){
                          return snap.hasData
                              ? OrderCard(
                                    itemCount: snap.data!.documents.length,
                                    data: snap.data!.documents,
                                    orderID: snapshot.data!.documents[index].documentID,
                                 )
                              :Center(child: circularProgress(),);
                        },
                      );
                    },
                  )
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
