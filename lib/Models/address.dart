class AddressModel {
  late String name;
  late String phoneNumber;
  late String flatNumber;
  late String city;
  late String state;
  late String pincode;

  AddressModel(
      {required this.name,
      required this.phoneNumber,
      required this.flatNumber,
      required this.city,
      required this.state,
      required this.pincode});

  AddressModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    flatNumber = json['flatNumber'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['flatNumber'] = this.flatNumber;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    return data;
  }
}
