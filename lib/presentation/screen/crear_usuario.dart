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

class UserAPI {
  static Future<void> sendUserData(String jsonData) async {
    var url = Uri.parse(
        'https://appatec-back-3c17836d3790.herokuapp.com/submit_form');
    var response = await http.post(url,
        body: jsonData, headers: {'Content-Type': 'application/json'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      return; // Success
    } else {
      throw Exception('Failed to send data'); // Error
    }
  }
}

class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  bool validateRut(String rut) {
    RegExp regExp = RegExp(r'^\d{8}-\d{1}$');
    return regExp.hasMatch(rut);
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNamePController = TextEditingController();
  final TextEditingController _lastNameMController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
  );

  bool _isLoading = false;
  bool _isGeneralManager = false;
  Uint8List? _signatureBytes;

  Future<void> _saveSignatureTemporarily() async {
    if (_signatureController.isNotEmpty) {
      final signature = await _signatureController.toPngBytes();
      if (signature != null) {
        setState(() {
          _signatureBytes = signature;
        });
      }
    }
  }

  Future<String?> _uploadSignatureToGoogleCloud(String userName) async {
    if (_signatureBytes != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/firma_$userName.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(_signatureBytes!);

      var client = await CloudStorageConfig.getClient();
      var bucketName = 'almacenamiento_pdf';
      var fileToUpload = File(imagePath);
      var media =
          storage.Media(fileToUpload.openRead(), fileToUpload.lengthSync());
      var destination = 'firmas/firma_$userName.png';

      try {
        var insertRequest = storage.Object()
          ..bucket = bucketName
          ..name = destination;

        var response = await storage.StorageApi(client)
            .objects
            .insert(insertRequest, bucketName, uploadMedia: media);
        print('Archivo cargado con éxito a Google Cloud Storage');

        var publicUrl =
            'https://storage.googleapis.com/$bucketName/$destination';
        print('URL de la firma: $publicUrl');

        return publicUrl;
      } catch (e) {
        print('Error al cargar el archivo: $e');
        return null;
      } finally {
        client.close();
      }
    }
    return null;
  }

  void onChangedApplyFormat(String text) {
    RUTValidator.formatFromTextController(_rutController);
  }

  final List<String> _roles = [
    'Jefe de Recursos Humanos',
    'Gerente',
    'Gerente General',
  ];

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String? signatureUrl;
      if (_isGeneralManager) {
        final fullName =
            '${_firstNameController.text}_${_lastNamePController.text}_${_lastNameMController.text}';
        signatureUrl = await _uploadSignatureToGoogleCloud(fullName);
      }

      Map<String, String> userData = {
        'rut': _rutController.text,
        'nombres': _firstNameController.text,
        'apellido_p': _lastNamePController.text,
        'apellido_m': _lastNameMController.text,
        'correo_electronico': _emailController.text,
        'rol': _selectedRole ?? '',
        'password': _passwordController.text,
        'firma': signatureUrl ?? 'null',
      };

      String jsonData = jsonEncode(userData);

      try {
        await UserAPI.sendUserData(jsonData);
        _showSuccessMessage();
      } catch (error) {
        _showErrorMessage();
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Datos enviados con éxito!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al enviar datos'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Usuario')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
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
                                controller: _rutController,
                                onChanged: onChangedApplyFormat,
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
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'Nombres',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
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
                              controller: _lastNamePController,
                              decoration: const InputDecoration(
                                labelText: 'Apellido Paterno',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
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
                              controller: _lastNameMController,
                              decoration: const InputDecoration(
                                labelText: 'Apellido Materno',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
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
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Correo Electrónico',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese el correo electrónico';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
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
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese la contraseña';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(7),
                            child: DropdownButtonFormField<String>(
                              value: _selectedRole,
                              hint: Text('Seleccione un rol'),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedRole = newValue;
                                  _isGeneralManager =
                                      newValue == 'Gerente General';
                                });
                              },
                              items: _roles.map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor seleccione un rol';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_isGeneralManager) ...[
                            const Text('Firma del Gerente General',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 20),
                            Signature(
                              controller: _signatureController,
                              height: 200,
                              backgroundColor: Colors.grey[200]!,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _signatureController.clear();
                                  },
                                  child: const Text('Borrar'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await _saveSignatureTemporarily();
                                  },
                                  child: const Text('Guardar'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                          ElevatedButton(
                            onPressed: _submitData,
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
