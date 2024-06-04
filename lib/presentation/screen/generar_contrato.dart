import 'package:flutter/material.dart';
import 'package:appatec_prototipo/presentation/screen/contrato_generado.dart';

class GenerateContractScreen extends StatefulWidget {
  const GenerateContractScreen({super.key});

  @override
  State<GenerateContractScreen> createState() => _GenerateContractScreenState();
}

class _GenerateContractScreenState extends State<GenerateContractScreen> {
  final TextEditingController _dateController1 = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();
  final TextEditingController _dateController3 = TextEditingController();

  bool _isChecked = false;

  @override
  void dispose() {
    _dateController1.dispose();
    _dateController2.dispose();
    _dateController3.dispose();
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
          // Primera columna: Datos personales
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
          // Segunda columna: Información laboral
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
          // Tercera columna: Detalles del contrato
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
      const TextField(
        decoration: InputDecoration(
          labelText: 'Nombres',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      const TextField(
        decoration: InputDecoration(
          labelText: 'Apellidos',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      const TextField(
        decoration: InputDecoration(
          labelText: 'Dirección Completa',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(
        value: 'Soltero',
        onChanged: (value) {},
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
        controller: _dateController1,
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
            String formattedDate = '${date.day}/${date.month}/${date.year}';
            _dateController1.text = formattedDate;
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
      const TextField(
        decoration: InputDecoration(
          labelText: 'RUT (Sin puntos y con guión)',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      const TextField(
        decoration: InputDecoration(
          labelText: 'Correo Electrónico',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(
        value: 'Chile',
        onChanged: (value) {},
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
        value: 'Fonasa',
        onChanged: (value) {},
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
        value: 'ProVida',
        onChanged: (value) {},
        items: const [
          DropdownMenuItem(value: 'ProVida', child: Text('ProVida')),
          DropdownMenuItem(value: 'Modelo', child: Text('Modelo')),
        ],
        decoration: const InputDecoration(
          labelText: 'Previsión AFP',
          border: OutlineInputBorder(),
        ),
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
        controller: _dateController2,
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
            String formattedDate = '${date.day}/${date.month}/${date.year}';
            _dateController2.text = formattedDate;
          }
        },
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _dateController3,
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
            String formattedDate = '${date.day}/${date.month}/${date.year}';
            _dateController3.text = formattedDate;
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
      const SizedBox(height: 20),
      const TextField(
        decoration: InputDecoration(
          labelText: 'Dirección de Trabajo',
          border: OutlineInputBorder(),
        ),
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
          const Expanded(child: Text('Acepto los términos y condiciones')),
        ],
      ),
      const SizedBox(height: 40),
      ElevatedButton(
        onPressed: _isChecked
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContractScreen()),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50)),
        child: const Text('Generar Contrato'),
      ),
    ];
  }

  void _showSalaryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Detalles del Sueldo'),
          children: <Widget>[
            const SimpleDialogOption(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Sueldo Base',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SimpleDialogOption(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Asignación de Colación',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SimpleDialogOption(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Gratificación (%)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SimpleDialogOption(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Bono de Asistencia',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SimpleDialogOption(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50)),
                child: const Text('Forma de Pago'),
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
