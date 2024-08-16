import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String addressProof;
  String createdAt;
  String phoneNumber;
  String pinCode;
  String state;
  String city;
  String token;
  String address;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.addressProof,
    required this.createdAt,
    required this.phoneNumber,
    required this.pinCode,
    required this.state,
    required this.city,
    required this.token,
    required this.address
  });

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      addressProof: map['addressProof'] ?? '',
      pinCode: map['pinCode']?? '',
      state: map['state']??'',
      city: map['city']?? '',
      token: map['token']??'',
      address: map['address']??''
    );
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get userId => _auth.currentUser?.uid;

  // to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
      "addressProof":addressProof,
      "pinCode":pinCode,
       "state":state,
  "city":city,
  "token":token,
  "address":address

    };
  }
}
