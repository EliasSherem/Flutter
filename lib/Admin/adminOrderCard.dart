import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fume/Admin/adminOrderDetails.dart';
import 'package:fume/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:fume/Widgets/orderCard.dart';

import '../Store/storehome.dart';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;
  AdminOrderCard({required this.itemCount, required this.data,required this.addressID,required this.orderID,required this.orderBy});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Route route;
        if(counter == 0){
          counter ++;
          route = MaterialPageRoute(builder: (c)=>AdminOrderDetails(orderID: orderID,orderBy: orderBy, addressID: addressID));
          Navigator.push(context, route);
        }

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
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount*190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c,index){
            ItemModel model = ItemModel.fromJson(data[index].data);
            return sourceOrderInfo(model, context, background: Colors.white);
          },
        ),
      ),
    );
  }
}


