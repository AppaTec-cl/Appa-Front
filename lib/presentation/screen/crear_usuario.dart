import 'dart:convert';
import 'dart:typed_data';
import 'package:ACG/endpoint/config.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:googleapis/storage/v1.dart' as storage;
import 'package:http/http.dart' as http;
import 'package:ACG/dart_rut_validator.dart';
import 'package:flutter/services.dart';

// Clase API para enviar datos del usuario al servidor
class UsuarioAPI {
  static Future<void> enviarDatosUsuario(String datosJson) async {
    var url = Uri.parse(
        'https://appatec-back-3c17836d3790.herokuapp.com/submit_form');
    var response = await http.post(url,
        body: datosJson, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return; // Éxito
    } else {
      throw Exception('Error al enviar datos'); // Error
    }
  }
}

// Pantalla del formulario de usuario
class PantallaFormularioUsuario extends StatefulWidget {
  @override
  _EstadoPantallaFormularioUsuario createState() =>
      _EstadoPantallaFormularioUsuario();
}

class _EstadoPantallaFormularioUsuario
    extends State<PantallaFormularioUsuario> {
  bool validarRut(String rut) {
    RegExp regExp = RegExp(r'^\d{8}-\d{1}$');
    return regExp.hasMatch(rut);
  }

  final _claveFormulario = GlobalKey<FormState>();
  final TextEditingController _controladorRut = TextEditingController();
  final TextEditingController _controladorNombres = TextEditingController();
  final TextEditingController _controladorApellidoP = TextEditingController();
  final TextEditingController _controladorApellidoM = TextEditingController();
  final TextEditingController _controladorCorreo = TextEditingController();
  final TextEditingController _controladorContrasena = TextEditingController();
  String? _rolSeleccionado;
  final SignatureController _controladorFirma = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
  );

  bool _estaCargando = false;
  bool _esGerenteGeneral = false;
  Uint8List? _firmaBytes;

  // Guarda la firma temporalmente en el dispositivo
  Future<void> _guardarFirmaTemporalmente() async {
    if (_controladorFirma.isNotEmpty) {
      final firma = await _controladorFirma.toPngBytes();
      if (firma != null) {
        setState(() {
          _firmaBytes = firma;
        });
      }
    }
  }

  // Sube la firma a Google Cloud Storage
  Future<String?> _subirFirmaAGoogleCloud(String nombreUsuario) async {
    if (_firmaBytes != null) {
      final directorio = await getTemporaryDirectory();
      final rutaImagen = '${directorio.path}/firma_$nombreUsuario.png';
      final archivoImagen = File(rutaImagen);
      await archivoImagen.writeAsBytes(_firmaBytes!);

      var cliente = await CloudStorageConfig.getClient();
      var nombreBucket = 'almacenamiento_pdf';
      var archivoASubir = File(rutaImagen);
      var media =
          storage.Media(archivoASubir.openRead(), archivoASubir.lengthSync());
      var destino = 'firmas/firma_$nombreUsuario.png';

      try {
        var solicitudInsertar = storage.Object()
          ..bucket = nombreBucket
          ..name = destino;

        var respuesta = await storage.StorageApi(cliente)
            .objects
            .insert(solicitudInsertar, nombreBucket, uploadMedia: media);
        var urlPublica =
            'https://storage.googleapis.com/$nombreBucket/$destino';
        return urlPublica;
      } catch (e) {
        return null;
      } finally {
        cliente.close();
      }
    }
    return null;
  }

  // Formatea el RUT ingresado
  void alCambiarAplicarFormato(String texto) {
    RUTValidator.formatFromTextController(_controladorRut);
  }

  final List<String> _roles = [
    'Jefe de Recursos Humanos',
    'Gerente',
    'Gerente General',
  ];

  // Envía los datos del formulario al servidor
  Future<void> _enviarDatos() async {
    if (_claveFormulario.currentState!.validate()) {
      setState(() {
        _estaCargando = true;
      });

      String? urlFirma;
      if (_esGerenteGeneral) {
        final nombreCompleto =
            '${_controladorNombres.text}_${_controladorApellidoP.text}_${_controladorApellidoM.text}';
        urlFirma = await _subirFirmaAGoogleCloud(nombreCompleto);
      }

      Map<String, String> datosUsuario = {
        'rut': _controladorRut.text,
        'nombres': _controladorNombres.text,
        'apellido_p': _controladorApellidoP.text,
        'apellido_m': _controladorApellidoM.text,
        'correo_electronico': _controladorCorreo.text,
        'rol': _rolSeleccionado ?? '',
        'password': _controladorContrasena.text,
        'firma': urlFirma ?? 'null',
      };

      String datosJson = jsonEncode(datosUsuario);

      try {
        await UsuarioAPI.enviarDatosUsuario(datosJson);
        _mostrarMensajeExito();
      } catch (error) {
        _mostrarMensajeError();
      } finally {
        setState(() {
          _estaCargando = false;
        });
      }
    }
  }

  // Muestra un mensaje de éxito
  void _mostrarMensajeExito() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Datos enviados con éxito!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Muestra un mensaje de error
  void _mostrarMensajeError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al enviar los datos!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Valida la contraseña ingresada
  String? _validarContrasena(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor ingrese la contraseña';
    }
    RegExp regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[A-Z]).{8,}$');
    if (!regExp.hasMatch(valor)) {
      return 'La contraseña debe tener al menos 8 caracteres, 1 letra, 1 número y 1 mayúscula';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Usuario')),
      body: _estaCargando
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _claveFormulario,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Column(
                        children: [
                          FocusTraversalOrder(
                            order: NumericFocusOrder(1),
                            child: TextFormField(
                                controller: _controladorRut,
                                onChanged: alCambiarAplicarFormato,
                                decoration: const InputDecoration(
                                  labelText: 'RUT (Sin puntos y sin guión)',
                                  border: OutlineInputBorder(),
                                ),
                                validator: RUTValidator(
                                        validationErrorText:
                                            'Ingrese RUT válido')
                                    .validator),
                          ),
                          const SizedBox(height: 16),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(2),
                            child: TextFormField(
                              controller: _controladorNombres,
                              decoration: const InputDecoration(
                                labelText: 'Nombres',
                                border: OutlineInputBorder(),
                              ),
                              validator: (valor) {
                                if (valor == null || valor.isEmpty) {
                                  return 'Por favor ingrese los nombres';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(3),
                            child: TextFormField(
                              controller: _controladorApellidoP,
                              decoration: const InputDecoration(
                                labelText: 'Apellido Paterno',
                                border: OutlineInputBorder(),
                              ),
                              validator: (valor) {
                                if (valor == null || valor.isEmpty) {
                                  return 'Por favor ingrese el apellido paterno';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(4),
                            child: TextFormField(
                              controller: _controladorApellidoM,
                              decoration: const InputDecoration(
                                labelText: 'Apellido Materno',
                                border: OutlineInputBorder(),
                              ),
                              validator: (valor) {
                                if (valor == null || valor.isEmpty) {
                                  return 'Por favor ingrese el apellido materno';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(5),
                            child: TextFormField(
                              controller: _controladorCorreo,
                              decoration: const InputDecoration(
                                labelText: 'Correo Electrónico',
                                border: OutlineInputBorder(),
                              ),
                              validator: (valor) {
                                if (valor == null || valor.isEmpty) {
                                  return 'Por favor ingrese el correo electrónico';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(valor)) {
                                  return 'Formato de correo inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(6),
                            child: TextFormField(
                              controller: _controladorContrasena,
                              decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: _validarContrasena,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(7),
                            child: DropdownButtonFormField<String>(
                              value: _rolSeleccionado,
                              hint: Text('Seleccione un rol'),
                              onChanged: (nuevoValor) {
                                setState(() {
                                  _rolSeleccionado = nuevoValor;
                                  _esGerenteGeneral =
                                      nuevoValor == 'Gerente General';
                                });
                              },
                              items: _roles.map((rol) {
                                return DropdownMenuItem(
                                  value: rol,
                                  child: Text(rol),
                                );
                              }).toList(),
                              validator: (valor) {
                                if (valor == null || valor.isEmpty) {
                                  return 'Por favor seleccione un rol';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_esGerenteGeneral) ...[
                            const Text('Firma del Gerente General',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 20),
                            Signature(
                              controller: _controladorFirma,
                              height: 200,
                              backgroundColor: Colors.grey[200]!,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _controladorFirma.clear();
                                  },
                                  child: const Text('Borrar'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await _guardarFirmaTemporalmente();
                                  },
                                  child: const Text('Guardar'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                          ElevatedButton(
                            onPressed: _enviarDatos,
                            child: Text('Enviar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
