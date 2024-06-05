import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:file_saver/file_saver.dart';

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
        title: const Text('Revisar Contrato - Gerente'),
      ),
      body: Row(
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
}
