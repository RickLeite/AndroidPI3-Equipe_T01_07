import 'package:cloud_firestore/cloud_firestore.dart';

class UsercredentialsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  validateCredentials(String email, String password) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('adm_acess')
          .where('email', isEqualTo: email)
          .get();

      print(querySnapshot);

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic>? data = docSnapshot.data();
        if (data != null &&
            data.containsKey('email') &&
            data.containsKey('chave') &&
            data['chave'] == password) {
          return true;
        }
      }
    } catch (e) {
      print('Failed: $e');
    }
  }
}
