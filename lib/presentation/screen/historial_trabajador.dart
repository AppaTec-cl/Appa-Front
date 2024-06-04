import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:file_saver/file_saver.dart';

class ContractWorkerPage extends StatefulWidget {
  const ContractWorkerPage({super.key});

  @override
  _ContractWorkerPageState createState() => _ContractWorkerPageState();
}

class _ContractWorkerPageState extends State<ContractWorkerPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? _localPath;

  late int randomNumber;

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
    } catch (e) {
      print('Error al descargar el archivo: $e');
    }
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
        print('Error al guardar el archivo: $e');
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
        title: const Text('Anexos de Contrato'),
      ),
      body: Row(
        children: <Widget>[
          // Expanded left sidebar with contract names as buttons
          Expanded(
            flex: 3, // Larger left sidebar
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10), // Increase vertical padding
                  child: TextButton(
                    onPressed: () {}, // Add functionality here
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Anexo de Contrato - Ajustes salariales 2024',
                          style: TextStyle(),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10), // Increase vertical padding
                  child: TextButton(
                    onPressed: () {}, // Add functionality here
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Anexo de Contrato - Extensión de servicios 2023',
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10), // Increase vertical padding
                  child: TextButton(
                    onPressed: () {}, // Add functionality here
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Anexo de Contrato - Cambio de horarios 2022',
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10), // Increase vertical padding
                  child: TextButton(
                    onPressed: () {}, // Add functionality here
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Anexo de Contrato - Expansión de infraestructura 2021',
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Vertical divider
          const Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: VerticalDivider(
              color: Colors.grey,
              width: 1,
            ),
          ),
          // Contract image section
          Expanded(
            flex: 8,
            child: Center(
              child: _localPath == null
                  ? const CircularProgressIndicator()
                  : SfPdfViewer.file(File(_localPath!)),
            ),
          ),
          // Vertical divider
          const Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: VerticalDivider(
              color: Colors.grey,
              width: 1,
            ),
          ),
          // Much smaller right sidebar with buttons
          Expanded(
            flex: 1, // Smaller right sidebar
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.download, size: 30),
                    onPressed: () {
                      saveFileLocally();
                    },
                  ),
                ),
                const SizedBox(height: 20), // Space between buttons
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.settings, size: 30),
                    onPressed: () {
                      _showConfigurations(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfigurations(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Configuraciones'),
          content: Column(children: <Widget>[
            ListTile(
              title: const Text('Ajuste 1'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Ajuste 2'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Ajuste 3'),
              onTap: () {},
            ),
          ]),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
