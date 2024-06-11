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

  Future<List<Map<String, dynamic>>> fetchUserPontoByEmailMonth(
      int year, int month) async {
    DateTime start = DateTime(year, month);
    DateTime end = DateTime(year, month + 1);

    String email = 'david.sm1@puccampinas.edu.br';

    QuerySnapshot querySnapshot = await _firestore
        .collection('user_pontos')
        .where('dateHour', isGreaterThanOrEqualTo: start)
        .where('dateHour', isLessThan: end)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
