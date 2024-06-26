import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserAPI {
  static Future<void> sendUserData(String jsonData) async {
    var url = Uri.parse('http://127.0.0.1:5000/submit_form');
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

  bool _isLoading = false;

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

      Map<String, String> userData = {
        'rut': _rutController.text,
        'nombres': _firstNameController.text,
        'apellido_p': _lastNamePController.text,
        'apellido_m': _lastNameMController.text,
        'correo_electronico': _emailController.text,
        'rol': _selectedRole ?? '',
        'password': _passwordController.text,
      };

      String jsonData = jsonEncode(userData);

      try {
        await UserAPI.sendUserData(jsonData);
        _showSuccessMessage();
      } catch (error) {
        _showSuccessMessage();
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
                    TextFormField(
                      controller: _rutController,
                      decoration: InputDecoration(labelText: 'RUT'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el RUT';
                        }
                        if (!validateRut(value)) {
                          return 'Formato de RUT inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: 'Nombres'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese los nombres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNamePController,
                      decoration:
                          InputDecoration(labelText: 'Apellido Paterno'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el apellido paterno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameMController,
                      decoration:
                          InputDecoration(labelText: 'Apellido Materno'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el apellido materno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration:
                          InputDecoration(labelText: 'Correo Electrónico'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el correo electrónico';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      hint: Text('Seleccione un rol'),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRole = newValue;
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitData,
                      child: Text('Enviar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
