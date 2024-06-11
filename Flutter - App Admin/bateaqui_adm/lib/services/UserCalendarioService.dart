import 'package:cloud_firestore/cloud_firestore.dart';

class UserCalendarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUserPonto() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('user_calendario').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchUserPontoByEmail(String email) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('user_calendario')
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
