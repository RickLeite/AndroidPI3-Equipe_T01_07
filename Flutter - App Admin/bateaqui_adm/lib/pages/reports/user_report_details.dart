import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:bateaqui_adm/services/UserPontosService.dart';

class UserReportsDetails extends StatefulWidget {
  late final String email;
  late final DateTime date;

  UserReportsDetails({required this.email, required this.date});

  @override
  _UserReportsDetailsState createState() => _UserReportsDetailsState();
}

class _UserReportsDetailsState extends State<UserReportsDetails> {
  UserPontosService _userPontosService = UserPontosService();
  List<Map<String, dynamic>> userPontoData = [];
  List<Map<String, dynamic>> userPontoDataFiltered = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchData(widget.email);
  }

  void _fetchData(String email) async {
    userPontoData = await _userPontosService.fetchUserPontoByEmailMonth(
        selectedDate.year, selectedDate.month);

    userPontoDataFiltered =
        userPontoData.where((item) => item['email'] == email).toList();

    setState(() {});

    if (userPontoDataFiltered.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nenhum dado encontrado'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Relatório gerado com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Pontos - Detalhes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Email: ${widget.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                'Mês/Ano:  ${widget.date.month.toString().padLeft(2, '0')}/${widget.date.year}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10), // Espaço entre o texto e o ListView
            Expanded(
              child: ListView.builder(
                itemCount: userPontoDataFiltered.length,
                itemBuilder: (context, index) {
                  Timestamp timestamp =
                      userPontoDataFiltered[index]['dateHour'];
                  DateTime dateTime = timestamp.toDate();
                  String formattedDate =
                      DateFormat('dd-MM-yyyy HH:mm').format(dateTime);

                  return ListTile(
                    title: Text("Registro $formattedDate"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
