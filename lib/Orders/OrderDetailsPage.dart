

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fume/Address/address.dart';
import 'package:fume/Config/config.dart';
import 'package:fume/Store/storehome.dart';
import 'package:fume/Widgets/loadingWidget.dart';
import 'package:fume/Widgets/orderCard.dart';
import 'package:fume/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fume/main.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;
  OrderDetails({required this.orderID});
  @override
  Widget build(BuildContext context) {
    getOrderId=orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .document(orderID).get(),
            builder: (c,snapshot){
              Map dataMap;
              if(snapshot.hasData){
                dataMap =snapshot.data!.data;
              }else{
                dataMap = snapshot.data!.data;
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(status: dataMap[EcommerceApp.isSuccess]),
                          SizedBox(height: 10.0,),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                r"$ " + dataMap[EcommerceApp.totalAmount].toString(),
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Order ID: " + getOrderId,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Ordered at: " + DateFormat("dd MMMM, yyyy - hh:mm aa")
                                  .format(DateTime.fromMicrosecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                              style: TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection("Items").where("shortInfo", whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                            builder: (c,dataSnapshot){
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      itemCount: dataSnapshot.data!.documents.length,
                                      data: dataSnapshot.data!.documents,
                                      orderID:orderID,
                                    )
                                  : Center(child: circularProgress(),);
                            },

                          ),
                          Divider(height: 2.0,),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                                .collection(EcommerceApp.subCollectionAddress)
                                .document(dataMap[EcommerceApp.addressID]).get(),
                            builder: (c,snap){
                              return snap.hasData
                                  ? ShippingDetails(model: AddressModel.fromJson(snap.data!.data))
                                  : Center(child: circularProgress(),);
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(child: circularProgress(),);
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;
  StatusBanner({required this.status});
  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Succesful" : msg = "Unsuccesful";
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors:[Colors.blue, Colors.lightBlueAccent],
              begin: const FractionalOffset(0.0,0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp
          )
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Text(
            "Order Placed" + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5.0,),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ShippingDetails extends StatelessWidget {
  final AddressModel model;
  ShippingDetails({required this.model});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Shipment Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0,vertical: 5.0),
          width: screenWidth*0.8,
          child: Table(
            children: [
              TableRow(
                children: [
                  KeyText("Name"),
                  Text(model.name),
                ],
              ),
              TableRow(
                children: [
                  KeyText("Phone Number"),
                  Text(model.phoneNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText("Flat Number"),
                  Text(model.flatNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText("City"),
                  Text(model.city),
                ],
              ),
              TableRow(
                children: [
                  KeyText("State"),
                  Text(model.state),
                ],
              ),
              TableRow(
                children: [
                  KeyText("Pin Code"),
                  Text(model.pincode),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: InkWell(
              onTap: (){
                confirmedUserOrderRecieved(context, getOrderId);
              },
             child: Container(
               decoration: new BoxDecoration(
                   gradient: new LinearGradient(
                       colors:[Colors.blue, Colors.lightBlueAccent],
                       begin: const FractionalOffset(0.0,0.0),
                       end: const FractionalOffset(1.0, 0.0),
                       stops: [0.0,1.0],
                       tileMode: TileMode.clamp
                   )
               ),
               width: MediaQuery.of(context).size.width-40.0,
               child: Center(
                 child: Text(
                   "Confirmed || Items recieved",
                   style: TextStyle(color: Colors.white, fontSize: 15.0),
                 ),
               ),
             ),
            ),
          ),
        ),
      ],

    );
  }
  confirmedUserOrderRecieved(BuildContext context, String myOrderId){
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(myOrderId)
        .delete();
    getOrderId = "";
    Route route = MaterialPageRoute(builder: (c)=> SplashScreen());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: "Order has been recived");
  }
}


