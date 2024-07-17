import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:appatec_prototipo/endpoint/contract.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:convert';

class ContractReviewPage extends StatefulWidget {
  const ContractReviewPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContractReviewPageState createState() => _ContractReviewPageState();
}

class _ContractReviewPageState extends State<ContractReviewPage>
    with SingleTickerProviderStateMixin {
  String? _localPath;

  late int randomNumber;
  Contract? _selectedContract;

  final TextEditingController _comentario = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Contract> pendingContracts = [];
  List<Contract> reviewedContracts = [];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(() {
      // Limpia el campo de búsqueda al cambiar de pestaña
      _searchController.clear();
      filterContracts(''); // Refresca la lista filtrada según la pestaña activa
    });
    fetchContracts("No Revisado").then((data) {
      setState(() {
        pendingContracts = data;
      });
    });
    fetchContracts("Revisado").then((data) {
      setState(() {
        reviewedContracts = data;
      });
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
      final fileInfo = await DefaultCacheManager().downloadFile(url);
      _localPath = fileInfo.file.path;
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar el PDF')),
      );
    }
  }

  String ensurePdfExtension(String fileName) {
    // Asegurarse de que el nombre del archivo termina con '.pdf'
    if (!fileName.toLowerCase().endsWith('.pdf')) {
      fileName += '.pdf'; // Agregar la extensión .pdf si no está presente
    }
    return fileName;
  }

  Future<void> saveFileLocally() async {
    if (_selectedContract == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecciona un contrato primero')),
      );
      return;
    }

    if (_localPath != null) {
      try {
        final file = File(_localPath!);
        final fileBytes = await file.readAsBytes();

        // Solicitar al usuario que seleccione la ubicación para guardar el archivo
        String? savePath = await FilePicker.platform.saveFile(
          dialogTitle: 'Guardar PDF del contrato',
          fileName:
              'Contrato de ${_selectedContract!.nombres}', // Usar el nombre del contrato actual
        );

        if (savePath != null) {
          File saveFile = File(savePath);
          String correctedName =
              ensurePdfExtension(saveFile.uri.pathSegments.last);

          String correctedFilePath = '${saveFile.parent.path}/$correctedName';
          File correctedFile = File(correctedFilePath);

          await correctedFile.writeAsBytes(fileBytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Archivo guardado exitosamente en: $savePath')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado cancelado')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el archivo: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No hay un archivo PDF descargado para guardar')),
      );
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisar Contrato - Gerente'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Pendientes'),
                    Tab(text: 'Revisados'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar contrato',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onChanged: filterContracts,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Para la pestaña de contratos pendientes
                    ListView.builder(
                      itemCount: filteredPendingContracts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              'Contrato de ${filteredPendingContracts[index].nombres} ${filteredPendingContracts[index].apellidos}'),
                          onTap: () {
                            setState(() {
                              _selectedContract = pendingContracts[index];
                              downloadFile(); // Llama a downloadFile para descargar el PDF seleccionado
                            });
                          },
                        );
                      },
                    ),

                    ListView.builder(
                      itemCount: filteredReviewedContracts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              'Contrato de ${filteredReviewedContracts[index].nombres} ${filteredReviewedContracts[index].apellidos}'),
                          onTap: () {
                            setState(() {
                              _selectedContract = reviewedContracts[index];
                              downloadFile(); // Llama a downloadFile para descargar el PDF seleccionado
                            });
                          },
                        );
                      },
                    ),
                  ],
                ))
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Center(
                    child: _localPath == null
                        ? Text("Seleccione un contrato para visualizar el PDF.")
                        : SfPdfViewer.file(File(_localPath!)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: _selectedContract != null
                              ? saveFileLocally
                              : null,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _comentario,
                          decoration: const InputDecoration(
                            labelText: 'Correcciones',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          onPressed: _selectedContract != null &&
                                  _selectedContract!.estado == 'No Revisado'
                              ? () {
                                  if (_comentario.text.isNotEmpty) {
                                    rejectContract(_selectedContract!.id,
                                        _comentario.text);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Por favor, ingrese un comentario antes de rechazar')),
                                    );
                                  }
                                }
                              : null,
                          child: const Text('Rechazar'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _selectedContract != null &&
                                _selectedContract!.estado == 'No Revisado'
                            ? () {
                                validateContract(_selectedContract!
                                    .id); // Asegúrate de pasar el ID correcto
                              }
                            : null,
                        child: const Text('Validar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> validateContract(String contractId) async {
    var url = Uri.parse('http://127.0.0.1:5000/update_contract/$contractId');
    try {
      var response = await http.post(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contrato validado exitosamente')),
        );
        // Opcional: Actualizar la UI o realizar acciones adicionales
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al validar el contrato')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el servidor: $e')),
      );
    }
  }

  Future<void> rejectContract(String contractId, String comentario) async {
    var url = Uri.parse('http://127.0.0.1:5000/reject_contract/$contractId');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'comentario': comentario}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contrato rechazado exitosamente')),
        );
        // Opcional: Actualizar la UI o realizar acciones adicionales
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al rechazar el contrato')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el servidor: $e')),
      );
    }
  }

  List<Contract> filteredPendingContracts = [];
  List<Contract> filteredReviewedContracts = [];

  void filterContracts(String query) {
    List<Contract> sourceList =
        _tabController?.index == 0 ? pendingContracts : reviewedContracts;
    List<Contract> targetList = _tabController?.index == 0
        ? filteredPendingContracts
        : filteredReviewedContracts;

    if (query.isEmpty) {
      setState(() {
        targetList.clear();
        targetList.addAll(sourceList);
      });
    } else {
      List<Contract> tmpList = [];
      for (Contract contract in sourceList) {
        if (contract.nombres.toLowerCase().contains(query.toLowerCase()) |
            contract.apellidos.toLowerCase().contains(query.toLowerCase())) {
          tmpList.add(contract);
        }
      }
      setState(() {
        targetList.clear();
        targetList.addAll(tmpList);
      });
    }
  }
}
