import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleModel {
  final DocumentReference reference;
  String name;
  String gender;
  String address;
  String phone;
  String photo;

  PeopleModel({
    this.reference,
    this.name = 'N/A',
    this.gender = 'N/A',
    this.address = 'N/A',
    this.phone = 'N/A',
    this.photo = 'N/A',
  });

  PeopleModel.fromMap(Map<dynamic, dynamic> map, {this.reference}) {
    name = map['name'];
    gender = map['gender'];
    address = map['address'];
    phone = map['phone'];
    photo = map['photo'];
  }

  PeopleModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> get toMap => {
        'name': name,
        'gender': gender,
        'address': address,
        'phone': phone,
        'photo': photo,
      };
}
