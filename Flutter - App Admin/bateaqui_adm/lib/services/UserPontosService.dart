import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bateaqui_adm/models/user.dart';
import 'package:uuid/uuid.dart';

class UserPontosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> fetchUserInfoByEmail(String email) async {
    try {
      print('Fetching user info for email: $email');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('user_pontos')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic>? data = docSnapshot.data();

        if (data != null &&
            data.containsKey('email') &&
            data.containsKey('identifier')) {
          return {
            'email': data['email'] as String,
            'identifier': data['identifier'] as String,
          };
        } else {
          throw Exception('Data format is incorrect');
        }
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      throw Exception('Failed to fetch user info: $e');
    }
  }

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

    QuerySnapshot querySnapshot = await _firestore
        .collection('user_pontos')
        .where('dateHour', isGreaterThanOrEqualTo: start)
        .where('dateHour', isLessThan: end)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> inserUserPonto(UserPonto userPonto) async {
    var uuid = Uuid();
    String docId = 'adm_' + uuid.v4();

    await _firestore
        .collection('user_pontos')
        .doc(docId)
        .set(userPonto.toMap());
  }
}
