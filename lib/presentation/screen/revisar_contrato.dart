import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';

class ContractReviewPage extends StatefulWidget {
  const ContractReviewPage({super.key});

  @override
  _ContractReviewPageState createState() => _ContractReviewPageState();
}

class _ContractReviewPageState extends State<ContractReviewPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? _localPath;

  late int randomNumber;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    downloadFile();
    randomNumber = Random().nextInt(300);
  }

  Future<void> downloadFile() async {
    final url =
        'https://www.turnerlibros.com/wp-content/uploads/2021/02/ejemplo.pdf'; // URL del PDF
    try {
      final fileInfo = await DefaultCacheManager().downloadFile(url);
      _localPath = fileInfo.file.path;
      setState(() {});
    } catch (e) {}
  }

  Future<void> saveFileLocally() async {
    if (_localPath != null) {
      try {
        final file = File(_localPath!);
        final fileBytes = await file.readAsBytes();
        final filePath = await FileSaver.instance.saveFile(
          name: 'Contrato $randomNumber.pdf',
          bytes: fileBytes,
          mimeType: MimeType.pdf,
        );
        if (filePath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Archivo guardado exitosamente en: $filePath')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al guardar el archivo')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el archivo')),
        );
      }
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
                          decoration: InputDecoration(
                            hintText: 'Buscar contrato',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        height: 47,
                        child: ElevatedButton(
                          onPressed: () => _showFilterDialog(context),
                          child: Icon(Icons.filter_list), // Icono de filtro
                          style: ElevatedButton.styleFrom(
                            // Color del botón
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Bordes redondeados
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    15), // Padding vertical para aumentar la altura del botón
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView(
                      children: <Widget>[
                        ListTile(
                          title: const Text('Contrato de Juan'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text('Contrato de Nicolás'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text('Contrato de Miguel'),
                          onTap: () {},
                        ),
                      ],
                    ),
                    ListView(
                      children: <Widget>[
                        ListTile(
                          title: const Text('Contrato de Ana'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text('Contrato de Pedro'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text('Contrato de María'),
                          onTap: () {},
                        ),
                      ],
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
                        ? const CircularProgressIndicator()
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
                          onPressed:
                              saveFileLocally, // Acción para descargar y guardar localmente
                        ),
                      ),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Correcciones',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Correcciones enviadas correctamente')),
                            );
                          },
                          child: const Text('Rechazar'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Contrato validado correctamente')),
                          );
                        },
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrar Contratos'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'RUT (Sin puntos y con guión)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: 'Elige Tipo',
                  onChanged: (value) {},
                  items: const [
                    DropdownMenuItem(
                        value: 'Elige Tipo', child: Text('Elige Tipo')),
                    DropdownMenuItem(
                        value: 'Analista Quimico',
                        child: Text('Analista Quimico')),
                    DropdownMenuItem(
                        value: 'Auxiliar de Laboratorio',
                        child: Text('Auxiliar de Laboratorio')),
                    DropdownMenuItem(
                        value: 'Tecnico Quimico',
                        child: Text('Tecnico Quimico')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Cargo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      // Usar DateFormat de intl para formatear la fecha
                      String formattedDate =
                          DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES')
                              .format(date);
                      _dateController.text = formattedDate;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aplicar Filtros'),
              onPressed: () {
                // Implementa la lógica para aplicar los filtros aquí
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
