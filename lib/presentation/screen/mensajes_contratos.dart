import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:ACG/endpoint/contract.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ContractReviewPage extends StatefulWidget {
  const ContractReviewPage({super.key});

  @override
  _ContractReviewPageState createState() => _ContractReviewPageState();
}

class _ContractReviewPageState extends State<ContractReviewPage> {
  String? _localPath;

  Contract? _selectedContract;

  final TextEditingController _comentario = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Contract> contracts = [];
  List<Contract> filteredContracts = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchContractsByStatuses(['Revisado', 'Revisado Gerente']).then((data) {
      setState(() {
        contracts = data;
      });
      print('Contracts loaded: ${contracts.length}');
    }).catchError((error) {
      print('Error fetching contracts: $error');
    });
  }

  Future<void> downloadFile() async {
    if (_selectedContract == null || _selectedContract!.contratoUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecciona un contrato primero')),
      );
      return;
    }

    final url =
        _selectedContract!.contratoUrl; // URL del PDF del contrato seleccionado
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getApplicationDocumentsDirectory();
        final filePath =
            path.join(directory.path, 'contrato_${_selectedContract!.rut}.pdf');

        final file = File(filePath);
        await file.writeAsBytes(bytes);

        setState(() {
          _localPath = filePath;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo descargado en: $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al descargar el archivo: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar el archivo: $e')),
      );
    }
  }

  void filterContracts(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        filteredContracts.clear();
      } else {
        isSearching = true;
        filteredContracts = contracts
            .where((contract) =>
                contract.rut.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Color getTileColor(Contract contract) {
    if (contract.revisionGerente == 1 && contract.revisionGerenteGeneral == 1) {
      return Colors.greenAccent.shade100; // Color pastel verde
    } else if (contract.revisionGerente == 1 &&
        contract.revisionGerenteGeneral == 0) {
      return Colors.purpleAccent.shade100; // Color pastel morado
    } else {
      return Colors.redAccent.shade100; // Color pastel rojo
    }
  }

  List<Contract> getContractsByStatus(int rg, int rge) {
    return contracts
        .where((contract) =>
            contract.revisionGerente == rg &&
            contract.revisionGerenteGeneral == rge)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisar Contrato'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar por RUT',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: filterContracts,
                  ),
                ),
                Expanded(
                  child: isSearching
                      ? ListView.builder(
                          itemCount: filteredContracts.length,
                          itemBuilder: (context, index) {
                            Contract contract = filteredContracts[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: getTileColor(contract),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  title: Text(contract.nombres),
                                  onTap: () {
                                    setState(() {
                                      _selectedContract = contract;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : ListView(
                          children: [
                            ExpansionTile(
                              title: Text('Contratos Rechazados por Gerente'),
                              children:
                                  getContractsByStatus(0, 0).map((contract) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: getTileColor(contract),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                          "${contract.nombres} ${contract.apellidos}"),
                                      onTap: () {
                                        setState(() {
                                          _selectedContract = contract;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            ExpansionTile(
                              title: Text(
                                  'Contratos Rechazados por Gerente General'),
                              children:
                                  getContractsByStatus(1, 0).map((contract) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: getTileColor(contract),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                          "${contract.nombres} ${contract.apellidos}"),
                                      onTap: () {
                                        setState(() {
                                          _selectedContract = contract;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            ExpansionTile(
                              title: Text('Contratos Aprobados'),
                              children:
                                  getContractsByStatus(1, 1).map((contract) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: getTileColor(contract),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                          "${contract.nombres} ${contract.apellidos}"),
                                      onTap: () {
                                        setState(() {
                                          _selectedContract = contract;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: _selectedContract == null
                ? const Center(child: Text('Selecciona un contrato para ver'))
                : Column(
                    children: [
                      Expanded(
                        child:
                            SfPdfViewer.network(_selectedContract!.contratoUrl),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_selectedContract != null &&
              (_selectedContract!.revisionGerente == 0 ||
                  _selectedContract!.revisionGerenteGeneral == 0))
            FloatingActionButton(
              heroTag: 'chat',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Comentario'),
                      content: Text(_selectedContract!.comentario),
                      actions: [
                        TextButton(
                          child: Text('Cerrar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.chat),
            ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'download',
            onPressed: downloadFile,
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }
}
