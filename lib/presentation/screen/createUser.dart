import 'package:flutter/material.dart';

class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNamePController = TextEditingController();
  final TextEditingController _lastNameMController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;

  // Lista de roles para el dropdown
  final List<String> _roles = [
    'Jefe de Recursos Humanos',
    'Gerente',
    'Gerente General',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Usuario')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _rutController,
                decoration: InputDecoration(labelText: 'RUT'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'Nombres'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNamePController,
                decoration: InputDecoration(labelText: 'Apellido Paterno'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameMController,
                decoration: InputDecoration(labelText: 'Apellido Materno'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: _selectedRole,
                decoration: InputDecoration(labelText: 'Rol'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                items: _roles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí se pueden añadir acciones como validar el formulario o guardar los datos
                      if (_formKey.currentState!.validate()) {
                        print('Generando usuario...');
                      }
                    },
                    child: Text('Generar Usuario'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
