import 'package:flutter/material.dart';
// import 'package:appatec_prototipo/presentation/screen/contrato_generado.dart';
import 'package:appatec_prototipo/generate/plantilla.dart';
import 'package:intl/intl.dart';

class GenerateContractScreen extends StatefulWidget {
  const GenerateContractScreen({super.key});

  @override
  State<GenerateContractScreen> createState() => _GenerateContractScreenState();
}

String _civil = 'Soltero';
String _nacionalidad = 'Chile';
String _salud = 'Fonasa';
String _afp = 'ProVida';

class _GenerateContractScreenState extends State<GenerateContractScreen> {
  final TextEditingController _dateControllernaci = TextEditingController();
  final TextEditingController _dateControllerini = TextEditingController();
  final TextEditingController _dateControllerfina = TextEditingController();
  final TextEditingController _nombres = TextEditingController();
  final TextEditingController _apellidos = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _rut = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _sueldoBase = TextEditingController();
  final TextEditingController _colacion = TextEditingController();
  final TextEditingController _bonoAsistencia = TextEditingController();
  final TextEditingController _nEmpleador = TextEditingController();
  final TextEditingController _rEmpleador = TextEditingController();

  bool _isChecked = false;

  @override
  void dispose() {
    _dateControllernaci.dispose();
    _dateControllerini.dispose();
    _dateControllerfina.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Contrato'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Row(
        children: [
          // First column: Personal details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildPersonalDetails(context),
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          // Second column: Labor information
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildWorkDetails(),
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          // Third column: Contract details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildContractDetails(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPersonalDetails(BuildContext context) {
    return [
      const Text('Datos Personales',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      TextField(
        controller: _nombres,
        decoration: const InputDecoration(
          labelText: 'Nombres',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _apellidos,
        decoration: InputDecoration(
          labelText: 'Apellidos',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _direccion,
        decoration: InputDecoration(
          labelText: 'Dirección Completa',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(
        value: _civil,
        onChanged: (value) {
          setState(() {
            _civil = value!;
          });
        },
        items: const [
          DropdownMenuItem(value: 'Soltero', child: Text('Soltero')),
          DropdownMenuItem(value: 'Casado', child: Text('Casado')),
        ],
        decoration: const InputDecoration(
          labelText: 'Estado Civil',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _dateControllernaci,
        decoration: const InputDecoration(
          labelText: 'Fecha de Nacimiento',
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
                DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES').format(date);
            _dateControllernaci.text = formattedDate;
          }
        },
      ),
    ];
  }

  List<Widget> _buildWorkDetails() {
    return [
      const Text('Información Laboral',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      TextField(
        controller: _rut,
        decoration: InputDecoration(
          labelText: 'RUT (Sin puntos y con guión)',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _correo,
        decoration: InputDecoration(
          labelText: 'Correo Electrónico',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(
        value: _nacionalidad,
        onChanged: (value) {
          setState(() {
            _nacionalidad = value!;
          });
        },
        items: const [
          DropdownMenuItem(value: 'Chile', child: Text('Chile')),
          DropdownMenuItem(value: 'Argentina', child: Text('Argentina')),
        ],
        decoration: const InputDecoration(
          labelText: 'Nacionalidad',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(
        value: _salud,
        onChanged: (value) {
          setState(() {
            _salud = value!;
          });
        },
        items: const [
          DropdownMenuItem(value: 'Fonasa', child: Text('Fonasa')),
          DropdownMenuItem(value: 'Isapre', child: Text('Isapre')),
        ],
        decoration: const InputDecoration(
          labelText: 'Sistema de Salud',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(
        value: _afp,
        onChanged: (value) {
          setState(() {
            _afp = value!;
          });
        },
        items: const [
          DropdownMenuItem(value: 'ProVida', child: Text('ProVida')),
          DropdownMenuItem(value: 'Modelo', child: Text('Modelo')),
        ],
        decoration: const InputDecoration(
          labelText: 'Previsión AFP',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () => _employerData(context),
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50)),
        child: const Text('Datos del Empleador'),
      ),
    ];
  }

  List<Widget> _buildContractDetails(BuildContext context) {
    return [
      const Text('Detalles del Contrato',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(
        value: 'Elige Tipo',
        onChanged: (value) {},
        items: const [
          DropdownMenuItem(value: 'Elige Tipo', child: Text('Elige Tipo')),
          DropdownMenuItem(
              value: 'Analista Quimico', child: Text('Analista Quimico')),
          DropdownMenuItem(
              value: 'Auxiliar de Laboratorio',
              child: Text('Auxiliar de Laboratorio')),
          DropdownMenuItem(
              value: 'Tecnico Quimico', child: Text('Tecnico Quimico')),
        ],
        decoration: const InputDecoration(
          labelText: 'Tipo de Cargo',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _dateControllerini,
        decoration: const InputDecoration(
          labelText: 'Fecha Inicio Contrato',
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
            String formattedDate =
                DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES').format(date);
            _dateControllerini.text = formattedDate;
          }
        },
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _dateControllerfina,
        decoration: const InputDecoration(
          labelText: 'Fecha Finalización Contrato',
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            String formattedDate =
                DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES').format(date);
            _dateControllerfina.text = formattedDate;
          }
        },
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () => _showSalaryDialog(context),
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50)),
        child: const Text('Sueldo'),
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
              });
            },
          ),
          const Expanded(child: Text('He revisado y confirmo los datos')),
        ],
      ),
      const SizedBox(height: 40),
      ElevatedButton(
        onPressed: _isChecked
            ? generarPdf(
                _nombres.text,
                _apellidos.text,
                _direccion.text,
                _civil,
                _dateControllernaci.text,
                _rut.text,
                _correo.text,
                _nacionalidad,
                _salud,
                _afp,
                _dateControllerini.text,
                _dateControllerfina.text,
                _sueldoBase.text,
                _colacion.text,
                _bonoAsistencia.text,
                _nEmpleador.text,
                _rEmpleador.text)
            : null,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50)),
        child: const Text('Generar Contrato'),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: _isChecked ? _onGenerateButtonPressed : null,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50)),
        child: const Text('Enviar Contrato'),
      ),
    ];
  }

  void _onGenerateButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("¿Seguro que quieres enviar el contrato?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            ElevatedButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Cierra el diálogo antes de generar el PDF// Asume que tienes esta función definida
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Contrato enviado correctamente")));
              },
            ),
          ],
        );
      },
    );
  }

  void _showSalaryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Detalles del Sueldo'),
          children: <Widget>[
            SimpleDialogOption(
              child: TextField(
                controller: _sueldoBase,
                decoration: InputDecoration(
                  labelText: 'Sueldo Base',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SimpleDialogOption(
              child: TextField(
                controller: _colacion,
                decoration: InputDecoration(
                  labelText: 'Asignación de Colación',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SimpleDialogOption(
              child: TextField(
                controller: _bonoAsistencia,
                decoration: InputDecoration(
                  labelText: 'Bono de Asistencia',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SimpleDialogOption(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _employerData(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Detalles del Empleador'),
          children: <Widget>[
            SimpleDialogOption(
              child: TextField(
                controller: _nEmpleador,
                decoration: InputDecoration(
                  labelText: 'Nombre Empleador',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SimpleDialogOption(
              child: TextField(
                controller: _rEmpleador,
                decoration: InputDecoration(
                  labelText: 'RUT Empleador',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SimpleDialogOption(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
