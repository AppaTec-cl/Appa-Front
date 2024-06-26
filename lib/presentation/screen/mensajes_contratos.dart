import 'package:flutter/material.dart';
import 'dart:math';

class ContractMessages extends StatefulWidget {
  @override
  _ContractMessagesDataState createState() => _ContractMessagesDataState();
}

class _ContractMessagesDataState extends State<ContractMessages> {
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    messages = List.generate(
            3,
            (_) => {
                  'message':
                      'El contrato número ${Random().nextInt(90000) + 10000} fue aprobado.',
                  'color': Colors.green
                }) +
        List.generate(
            2,
            (_) => {
                  'message':
                      'El contrato número ${Random().nextInt(90000) + 10000} fue rechazado. Motivo: Incumplimiento de términos.',
                  'color': Colors.red
                });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Revision de Contratos'),
      ),
      body: ListView(
        children: messages
            .map((msg) => Card(
                  color: msg['color'],
                  child: ListTile(
                    title: Text(
                      msg['message'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
