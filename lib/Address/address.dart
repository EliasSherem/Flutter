import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fume/Config/config.dart';
import 'package:fume/Models/address.dart';
import 'package:fume/Orders//placeOrder.dart';
import 'package:fume/Widgets/customAppBar.dart';
import 'package:fume/Widgets/loadingWidget.dart';
import 'package:fume/Widgets/wideButton.dart';
import 'package:fume/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget {
  final double totalAmount;
  const Address({required this.totalAmount});
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Address",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),
                ),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address,c){
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.subCollectionAddress).snapshots(),
                  builder: (context,snapshot){
                    return !snapshot.hasData
                        ? Center(child: circularProgress(),)
                        : snapshot.data!.documents.length == 0
                        ? noAddressCard()
                        : ListView.builder(
                          itemCount: snapshot.data!.documents.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                                return AddressCard(
                                  currentIndex: address.count,
                                  value: index,
                                  addressId: snapshot.data!.documents[index].documentID,
                                  totalAmount: widget.totalAmount,
                                  model: AddressModel.fromJson(snapshot.data!.documents[index].data),
                                );
                          },
                        );
                  },
                ),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: (){
              Route route = MaterialPageRoute(builder: (_)=> AddAddress());
              Navigator.pushReplacement(context, route);
            },
            label: Text("Add New Address"),
          backgroundColor: Colors.blue,
          icon: Icon(Icons.add_location),
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.blue.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location, color: Colors.white,),
            Text("No shipment address has been saved"),
            Text("Please add your shipment address"),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;
  AddressCard({
    required this.model,
    required this.currentIndex,
    required this.addressId,
    required this.totalAmount,
    required this.value,
});
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Provider.of<AddressChanger>(context,listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.blueAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.blue,
                  onChanged: (val){
                    Provider.of<AddressChanger>(context, listen: false).displayResult(val as int);

                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth*0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText("Name"),
                              Text(widget.model.name),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText("Phone Number"),
                              Text(widget.model.phoneNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText("Flat Number"),
                              Text(widget.model.flatNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText("City"),
                              Text(widget.model.city),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText("State"),
                              Text(widget.model.state),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText("Pin Code"),
                              Text(widget.model.pincode),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                  ? WideButton(
                        message: "Proceed",
                        onPressed: (){
                          Route route = MaterialPageRoute(builder: (c)=>PaymentPage(
                            addressId:widget.addressId,
                            totalAmount: widget.totalAmount,
                          ));
                          Navigator.push(context, route);
                        },
                    )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;
  KeyText(this.msg);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
    );
  }
}
