import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/UserPontosService.dart';

class UserReports extends StatefulWidget {
  @override
  _UserReportsState createState() => _UserReportsState();
}

class _UserReportsState extends State<UserReports> {
  UserPontosService _userPontosService = UserPontosService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ponto'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userPontosService.fetchUserPonto(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum dado encontrado'));
          }

          List<Map<String, dynamic>> userPontoData = snapshot.data!;
          return ListView.builder(
            itemCount: userPontoData.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(userPontoData[index]['email'].toString()),
                subtitle: Text(userPontoData[index]['dateHour'].toString()),
              );
            },
          );
        },
      ),
    );
  }
}
