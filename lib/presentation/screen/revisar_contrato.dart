import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:ACG/endpoint/contract.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:convert';

// Página para revisar contratos
class PaginaRevisarContrato extends StatefulWidget {
  const PaginaRevisarContrato({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EstadoPaginaRevisarContrato createState() => _EstadoPaginaRevisarContrato();
}

class _EstadoPaginaRevisarContrato extends State<PaginaRevisarContrato>
    with SingleTickerProviderStateMixin {
  String? _rutaLocal;

  Contract? _contratoSeleccionado;

  final TextEditingController _controladorComentario = TextEditingController();
  final TextEditingController _controladorBusqueda = TextEditingController();

  List<Contract> contratosPendientes = [];
  List<Contract> contratosRevisados = [];

  TabController? _controladorPestanas;

  @override
  void initState() {
    super.initState();
    _controladorPestanas = TabController(length: 2, vsync: this);
    _controladorPestanas?.addListener(() {
      // Limpia el campo de búsqueda al cambiar de pestaña
      _controladorBusqueda.clear();
      filtrarContratos(
          ''); // Refresca la lista filtrada según la pestaña activa
    });
    fetchContracts("No Revisado").then((data) {
      setState(() {
        contratosPendientes = data;
      });
    });
    fetchContracts("Revisado").then((data) {
      setState(() {
        contratosRevisados = data;
      });
    });
  }

  // Descarga el archivo PDF del contrato seleccionado
  Future<void> descargarArchivo() async {
    if (_contratoSeleccionado == null ||
        _contratoSeleccionado!.contratoUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecciona un contrato primero')),
      );
      return;
    }

    final url = _contratoSeleccionado!
        .contratoUrl; // URL del PDF del contrato seleccionado
    try {
      final fileInfo = await DefaultCacheManager().downloadFile(url);
      _rutaLocal = fileInfo.file.path;
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar el PDF')),
      );
    }
  }

  // Asegura que el nombre del archivo tenga la extensión '.pdf'
  String asegurarExtensionPdf(String nombreArchivo) {
    if (!nombreArchivo.toLowerCase().endsWith('.pdf')) {
      nombreArchivo += '.pdf'; // Agregar la extensión .pdf si no está presente
    }
    return nombreArchivo;
  }

  // Guarda el archivo PDF localmente
  Future<void> guardarArchivoLocalmente() async {
    if (_contratoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecciona un contrato primero')),
      );
      return;
    }

    if (_rutaLocal != null) {
      try {
        final file = File(_rutaLocal!);
        final fileBytes = await file.readAsBytes();

        // Solicitar al usuario que seleccione la ubicación para guardar el archivo
        String? rutaGuardado = await FilePicker.platform.saveFile(
          dialogTitle: 'Guardar PDF del contrato',
          fileName:
              'Contrato de ${_contratoSeleccionado!.nombres}', // Usar el nombre del contrato actual
        );

        if (rutaGuardado != null) {
          File archivoGuardado = File(rutaGuardado);
          String nombreCorregido =
              asegurarExtensionPdf(archivoGuardado.uri.pathSegments.last);

          String rutaArchivoCorregido =
              '${archivoGuardado.parent.path}/$nombreCorregido';
          File archivoCorregido = File(rutaArchivoCorregido);

          await archivoCorregido.writeAsBytes(fileBytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Archivo guardado exitosamente en: $rutaGuardado')),
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
    _controladorPestanas?.dispose();
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
                  controller: _controladorPestanas,
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
                          controller: _controladorBusqueda,
                          decoration: InputDecoration(
                            hintText: 'Buscar contrato',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onChanged: filtrarContratos,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _controladorPestanas,
                    children: [
                      // Para la pestaña de contratos pendientes
                      ListView.builder(
                        itemCount: contratosPendientesFiltrados.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'Contrato de ${contratosPendientesFiltrados[index].nombres} ${contratosPendientesFiltrados[index].apellidos}'),
                            onTap: () {
                              setState(() {
                                _contratoSeleccionado =
                                    contratosPendientes[index];
                                descargarArchivo(); // Llama a descargarArchivo para descargar el PDF seleccionado
                              });
                            },
                          );
                        },
                      ),

                      ListView.builder(
                        itemCount: contratosRevisadosFiltrados.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'Contrato de ${contratosRevisadosFiltrados[index].nombres} ${contratosRevisadosFiltrados[index].apellidos}'),
                            onTap: () {
                              setState(() {
                                _contratoSeleccionado =
                                    contratosRevisados[index];
                                descargarArchivo(); // Llama a descargarArchivo para descargar el PDF seleccionado
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
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
                    child: _rutaLocal == null
                        ? Text("Seleccione un contrato para visualizar el PDF.")
                        : SfPdfViewer.file(File(_rutaLocal!)),
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
                          onPressed: _contratoSeleccionado != null
                              ? guardarArchivoLocalmente
                              : null,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controladorComentario,
                          decoration: const InputDecoration(
                            labelText: 'Correcciones',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          onPressed: _contratoSeleccionado != null &&
                                  _contratoSeleccionado!.estado == 'No Revisado'
                              ? () {
                                  if (_controladorComentario.text.isNotEmpty) {
                                    rechazarContrato(_contratoSeleccionado!.id,
                                        _controladorComentario.text);
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
                        onPressed: _contratoSeleccionado != null &&
                                _contratoSeleccionado!.estado == 'No Revisado'
                            ? () {
                                validarContrato(_contratoSeleccionado!
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

  // Valida el contrato enviando el ID al servidor
  Future<void> validarContrato(String idContrato) async {
    var url = Uri.parse(
        'https://appatec-back-3c17836d3790.herokuapp.com/update_contract/$idContrato');
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

  // Rechaza el contrato enviando el ID y el comentario al servidor
  Future<void> rechazarContrato(String idContrato, String comentario) async {
    var url = Uri.parse(
        'https://appatec-back-3c17836d3790.herokuapp.com/reject_contract/$idContrato');
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
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el servidor: $e')),
      );
    }
  }

  List<Contract> contratosPendientesFiltrados = [];
  List<Contract> contratosRevisadosFiltrados = [];

  // Filtra los contratos según el texto de búsqueda
  void filtrarContratos(String consulta) {
    List<Contract> listaFuente = _controladorPestanas?.index == 0
        ? contratosPendientes
        : contratosRevisados;
    List<Contract> listaDestino = _controladorPestanas?.index == 0
        ? contratosPendientesFiltrados
        : contratosRevisadosFiltrados;

    if (consulta.isEmpty) {
      setState(() {
        listaDestino.clear();
        listaDestino.addAll(listaFuente);
      });
    } else {
      List<Contract> tmpList = [];
      for (Contract contrato in listaFuente) {
        if (contrato.nombres.toLowerCase().contains(consulta.toLowerCase()) ||
            contrato.apellidos.toLowerCase().contains(consulta.toLowerCase())) {
          tmpList.add(contrato);
        }
      }
      setState(() {
        listaDestino.clear();
        listaDestino.addAll(tmpList);
      });
    }
  }
}
