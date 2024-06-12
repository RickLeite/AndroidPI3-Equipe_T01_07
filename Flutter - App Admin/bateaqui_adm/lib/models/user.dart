import 'package:cloud_firestore/cloud_firestore.dart';

class UserPonto {
  final Timestamp dateHour;
  final String email;
  final String identifier;
  final String name;

  UserPonto({
    required this.dateHour,
    required this.email,
    required this.identifier,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'dateHour': Timestamp.fromDate(this.dateHour.toDate()),
      'email': this.email,
      'identifier': this.identifier,
      'name': this.name,
    };
  }
}
