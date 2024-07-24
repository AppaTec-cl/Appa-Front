import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:ACG/endpoint/contract.dart';
import 'package:ACG/generate/signed/analista_quimico.dart';
import 'package:ACG/generate/signed/analista_quimico_indef.dart';
import 'package:ACG/generate/signed/auxiliar_laboratorio.dart';
import 'package:ACG/generate/signed/auxiliar_laboratorio_indef.dart';
import 'package:ACG/generate/signed/tecnico_quimico.dart';
import 'package:ACG/generate/signed/tecnico_quimico_indef.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:convert';

// Página de Gerente para revisar contratos
class PaginaGerente extends StatefulWidget {
  const PaginaGerente({super.key});

  @override
  _EstadoPaginaGerente createState() => _EstadoPaginaGerente();
}

class _EstadoPaginaGerente extends State<PaginaGerente>
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
    fetchContracts("Revisado").then((data) {
      setState(() {
        contratosPendientes = data;
      });
    });
    fetchContracts("Revisado Gerente").then((data) {
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
                                  _contratoSeleccionado!.estado == 'Revisado'
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
                                _contratoSeleccionado!.estado == 'Revisado'
                            ? () async {
                                await generarPdf(
                                  _contratoSeleccionado!.nombres,
                                  _contratoSeleccionado!.apellidos,
                                  _contratoSeleccionado!.direccion,
                                  _contratoSeleccionado!.estadoCivil,
                                  _contratoSeleccionado!.fechaNacimiento,
                                  _contratoSeleccionado!.rut,
                                  _contratoSeleccionado!.mail,
                                  _contratoSeleccionado!.nacionalidad,
                                  _contratoSeleccionado!.sistemaSalud,
                                  _contratoSeleccionado!.afp,
                                  _contratoSeleccionado!.fechaInicioTrabajo,
                                  _contratoSeleccionado!.fechaFinalTrabajo,
                                  _contratoSeleccionado!.sueldoBase,
                                  _contratoSeleccionado!.asignacioColacion,
                                  _contratoSeleccionado!.bonoAsistencia,
                                  _contratoSeleccionado!.nombreEmpleador,
                                  _contratoSeleccionado!.rutEmpleador,
                                  obtenerEnlaceFirma(),
                                  _contratoSeleccionado!.id,
                                );
                              }
                            : null,
                        child: const Text('Firmar'),
                      )
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
        'https://appatec-back-3c17836d3790.herokuapp.com/update_contract_gerent/$idContrato');
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
        'https://appatec-back-3c17836d3790.herokuapp.com/reject_contract_gerent/$idContrato');
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

  // Obtiene el enlace de la firma
  Future<String?> obtenerEnlaceFirma() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getString('userId') ?? 'default_user_id';

      final response = await http.post(
        Uri.parse('https://appatec-back-3c17836d3790.herokuapp.com/sign'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id_usuario': idUsuario,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[
            'firma']; // Suponiendo que 'firma' es la clave que contiene el enlace
      } else {
        throw Exception(
            'Failed to fetch signature link: ${response.statusCode}');
      }
    } catch (e) {
      return null;
    }
  }

  // Valida el formato del correo electrónico
  String? validarCorreo(String? valor) {
    if (valor == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(valor)) {
      return 'Formato de correo inválido';
    }
    return null;
  }

  // Genera el PDF del contrato según el cargo y la duración del trabajo
  Future<void> generarPdf(
      String nombres,
      String apellidos,
      String direccion,
      String civil,
      String fechaNacimiento,
      String rut,
      String correo,
      String nacionalidad,
      String salud,
      String afp,
      String fechaInicio,
      String fechaFin,
      String sueldoBase,
      String colacion,
      String bonoAsistencia,
      String nombreEmpleador,
      String rutEmpleador,
      urlImagen,
      String idContrato) async {
    if (_contratoSeleccionado?.cargo == 'Analista Quimico' &&
        _contratoSeleccionado?.fechaFinalTrabajo != 'Indefinido') {
      await generarPdfAnalistaQ(
          nombres,
          apellidos,
          direccion,
          civil,
          fechaNacimiento,
          rut,
          correo,
          nacionalidad,
          salud,
          afp,
          fechaInicio,
          fechaFin,
          sueldoBase,
          colacion,
          bonoAsistencia,
          nombreEmpleador,
          rutEmpleador,
          urlImagen,
          idContrato);
    } else if (_contratoSeleccionado?.cargo == 'Analista Quimico' &&
        _contratoSeleccionado?.fechaFinalTrabajo == 'Indefinido') {
      await generarPdfAnalistaQIndef(
          nombres,
          apellidos,
          direccion,
          civil,
          fechaNacimiento,
          rut,
          correo,
          nacionalidad,
          salud,
          afp,
          fechaInicio,
          sueldoBase,
          colacion,
          bonoAsistencia,
          nombreEmpleador,
          rutEmpleador,
          urlImagen,
          idContrato);
    } else if (_contratoSeleccionado?.cargo == 'Auxiliar Laboratorio' &&
        _contratoSeleccionado?.fechaFinalTrabajo != 'Indefinido') {
      await generarPdfAuxiliarL(
          nombres,
          apellidos,
          direccion,
          civil,
          fechaNacimiento,
          rut,
          correo,
          nacionalidad,
          salud,
          afp,
          fechaInicio,
          fechaFin,
          sueldoBase,
          colacion,
          bonoAsistencia,
          nombreEmpleador,
          rutEmpleador,
          urlImagen,
          idContrato);
    } else if (_contratoSeleccionado?.cargo == 'Auxiliar Laboratorio' &&
        _contratoSeleccionado?.fechaFinalTrabajo == 'Indefinido') {
      await generarPdfAuxiliarLIndef(
          nombres,
          apellidos,
          direccion,
          civil,
          fechaNacimiento,
          rut,
          correo,
          nacionalidad,
          salud,
          afp,
          fechaInicio,
          sueldoBase,
          colacion,
          bonoAsistencia,
          nombreEmpleador,
          rutEmpleador,
          urlImagen,
          idContrato);
    } else if (_contratoSeleccionado?.cargo == 'Tecnico Quimico' &&
        _contratoSeleccionado?.fechaFinalTrabajo != 'Indefinido') {
      await generarPdfTecnicoQ(
          nombres,
          apellidos,
          direccion,
          civil,
          fechaNacimiento,
          rut,
          correo,
          nacionalidad,
          salud,
          afp,
          fechaInicio,
          fechaFin,
          sueldoBase,
          colacion,
          bonoAsistencia,
          nombreEmpleador,
          rutEmpleador,
          urlImagen,
          idContrato);
    } else if (_contratoSeleccionado?.cargo == 'Tecnico Quimico' &&
        _contratoSeleccionado?.fechaFinalTrabajo == 'Indefinido') {
      await generarPdfTecnicoQIndef(
          nombres,
          apellidos,
          direccion,
          civil,
          fechaNacimiento,
          rut,
          correo,
          nacionalidad,
          salud,
          afp,
          fechaInicio,
          sueldoBase,
          colacion,
          bonoAsistencia,
          nombreEmpleador,
          rutEmpleador,
          urlImagen,
          idContrato);
    }
  }
}
