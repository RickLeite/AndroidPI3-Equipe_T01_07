import 'package:cloud_firestore/cloud_firestore.dart';

class UserPontosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUserPonto() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('user_pontos').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
