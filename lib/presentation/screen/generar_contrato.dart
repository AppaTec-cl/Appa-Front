import 'package:flutter/material.dart';
//import 'dart:ui' as ui;
import 'package:country_picker/country_picker.dart';
import 'package:ACG/generate/plantilla_analista_quimico.dart';
import 'package:ACG/generate/plantilla_auxiliar_laboratorio.dart';
import 'package:ACG/generate/plantilla_tecnico_quimico.dart';
import 'package:ACG/generate/plantilla_analista_quimico_indef.dart';
import 'package:ACG/generate/plantilla_auxiliar_laboratorio_indef.dart';
import 'package:ACG/generate/plantilla_tecnico_quimico_indef.dart';
import 'package:ACG/dart_rut_validator.dart';
import 'package:ACG/endpoint/contract.dart';
import 'package:intl/intl.dart';

class GenerateContractScreen extends StatefulWidget {
  final String rut;

  const GenerateContractScreen({required this.rut, super.key});

  @override
  State<GenerateContractScreen> createState() => _GenerateContractScreenState();
}

String _civil = 'Soltero';
String _nacionalidad = 'Chile';
String _salud = 'Fonasa';
String _afp = 'ProVida';
String _tipoC = 'Analista Quimico';

class _GenerateContractScreenState extends State<GenerateContractScreen> {
  final _formKey = GlobalKey<FormState>();
  //final _salaryKey = GlobalKey<FormState>();
  final TextEditingController _dateControllernaci = TextEditingController();
  final TextEditingController _dateControllerini = TextEditingController();
  final TextEditingController _dateControllerfina =
      TextEditingController(text: "Indefinido");
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

  void onChangedApplyFormat(String text) {
    RUTValidator.formatFromTextController(_rut);
  }

  void onChangedApplyFormat1(String text) {
    RUTValidator.formatFromTextController(_rEmpleador);
  }

  List<Country> countries = [];

  void loadCountries() {
    countries = CountryService().getAll()
      ..removeWhere((country) =>
          country.name == 'South Georgia and the South Sandwich Islands');
  }

  @override
  void initState() {
    super.initState();
    loadCountries();
    _rut.text = widget.rut;
    _fetchContractData(widget.rut);
  }

  Future<void> _fetchContractData(String rut) async {
    ContractService service = ContractService();
    Contract? contract = await service.getContractByRut(rut);
    if (contract != null) {
      setState(() {
        _nombres.text = contract.nombres;
        _apellidos.text = contract.apellidos;
        _direccion.text = contract.direccion;
        _correo.text = contract.mail;
        _colacion.text = contract.asignacioColacion;
        _bonoAsistencia.text = contract.bonoAsistencia;
        _civil = contract.estadoCivil;
        _nacionalidad = contract.nacionalidad;
        _salud = contract.sistemaSalud;
        _afp = contract.afp;
        _dateControllernaci.text = contract.fechaNacimiento;
      });
    }
  }

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
      body: Form(
        key: _formKey,
        child: Row(
          children: [
            // First column: Personal details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildPersonalDetails(context),
                      ),
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
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildWorkDetails(),
                      ),
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
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildContractDetails(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPersonalDetails(BuildContext context) {
    return [
      const Text('Datos Personales',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(1),
        child: TextFormField(
          controller: _nombres,
          decoration: const InputDecoration(
            labelText: 'Nombres',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese nombres';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(2),
        child: TextFormField(
          controller: _apellidos,
          decoration: InputDecoration(
            labelText: 'Apellidos',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese apellidos';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(3),
        child: TextFormField(
          controller: _direccion,
          decoration: InputDecoration(
            labelText: 'Dirección Completa',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese dirección';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(4),
        child: DropdownButtonFormField<String>(
          value: _civil,
          onChanged: (value) {
            setState(() {
              _civil = value!;
            });
          },
          items: const [
            DropdownMenuItem(value: 'Soltero', child: Text('Soltero')),
            DropdownMenuItem(value: 'Casado', child: Text('Casado')),
            DropdownMenuItem(value: 'Divorciado', child: Text('Divorciado')),
            DropdownMenuItem(value: 'Viudo', child: Text('Viudo')),
          ],
          decoration: const InputDecoration(
            labelText: 'Estado Civil',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(5),
        child: TextFormField(
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
                  DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES')
                      .format(date);
              _dateControllernaci.text = formattedDate;
            }
          },
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(6),
        child: DropdownButtonFormField<String>(
          value: _nacionalidad,
          onChanged: (value) {
            setState(() {
              _nacionalidad = value!;
            });
          },
          items: countries.map((country) {
            return DropdownMenuItem(
              value: country.name,
              child: Text(country.name),
            );
          }).toList(),
          decoration: const InputDecoration(
            labelText: 'Nacionalidad',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(7),
        child: TextFormField(
            controller: _rut,
            onChanged: onChangedApplyFormat,
            decoration: const InputDecoration(
              labelText: 'RUT',
              border: OutlineInputBorder(),
            ),
            validator: RUTValidator(validationErrorText: 'Ingrese RUT válido')
                .validator),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(8),
        child: TextFormField(
          controller: _correo,
          decoration: const InputDecoration(
            labelText: 'Correo Electrónico',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese correo electrónico';
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> _buildWorkDetails() {
    return [
      const Text('Datos Laborales',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(9),
        child: DropdownButtonFormField<String>(
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
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(10),
        child: DropdownButtonFormField<String>(
          value: _afp,
          onChanged: (value) {
            setState(() {
              _afp = value!;
            });
          },
          items: const [
            DropdownMenuItem(value: 'ProVida', child: Text('ProVida')),
            DropdownMenuItem(value: 'Cuprum', child: Text('Cuprum')),
            DropdownMenuItem(value: 'PlanVital', child: Text('PlanVital')),
            DropdownMenuItem(value: 'Modelo', child: Text('Modelo')),
            DropdownMenuItem(value: 'Uno', child: Text('Uno')),
            DropdownMenuItem(value: 'Habitat', child: Text('Habitat')),
          ],
          decoration: const InputDecoration(
            labelText: 'Previsión AFP',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: const NumericFocusOrder(11),
        child: DropdownButtonFormField<String>(
          value: _tipoC,
          onChanged: (value) {
            setState(() {
              _tipoC = value!;
            });
          },
          items: const [
            DropdownMenuItem(
                value: 'Analista Quimico', child: Text('Analista Quimico')),
            DropdownMenuItem(
                value: 'Auxiliar de Laboratorio',
                child: Text('Auxiliar de Laboratorio')),
            DropdownMenuItem(
                value: 'Tecnico Quimico', child: Text('Tecnico Quimico')),
          ],
          decoration: const InputDecoration(
            labelText: 'Tipo de Contrato',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(12),
        child: TextFormField(
          controller: _dateControllerini,
          decoration: const InputDecoration(
            labelText: 'Fecha de Inicio de Contrato',
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
                  DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES')
                      .format(date);
              _dateControllerini.text = formattedDate;
            }
          },
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(13),
        child: TextFormField(
          controller: _dateControllerfina,
          decoration: const InputDecoration(
            labelText: 'Fecha de Finaliación de Contrato',
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
                  DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES')
                      .format(date);
              _dateControllerfina.text = formattedDate;
            }
          },
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(14),
        child: TextFormField(
          controller: _sueldoBase,
          decoration: const InputDecoration(
            labelText: 'Sueldo Base',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese sueldo base';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(15),
        child: TextFormField(
          controller: _colacion,
          decoration: const InputDecoration(
            labelText: 'Asignación Colación',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese colación';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(16),
        child: TextFormField(
          controller: _bonoAsistencia,
          decoration: const InputDecoration(
            labelText: 'Bono Asistencia',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese bono asistencia';
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> _buildContractDetails(BuildContext context) {
    return [
      const Text('Detalles del Empleador',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(17),
        child: TextFormField(
          controller: _nEmpleador,
          decoration: const InputDecoration(
            labelText: 'Nombre del Empleador',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese nombre del empleador';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(18),
        child: TextFormField(
          controller: _rEmpleador,
          onChanged: onChangedApplyFormat1,
          decoration: const InputDecoration(
            labelText: 'RUT del Empleador',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese RUT del empleador';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 20),
      CheckboxListTile(
        title: const Text("Aseguro que los datos son correctos"),
        value: _isChecked,
        onChanged: (bool? value) {
          setState(() {
            _isChecked = value!;
          });
        },
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && _isChecked) {
            _generateContract();
          } else if (!_isChecked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Debe aceptar la casilla de verificación'),
              ),
            );
          }
        },
        child: const Text('Generar Contrato'),
      ),
    ];
  }

  Future<void> _generateContract() async {
    // Otras validaciones necesarias
    if (_formKey.currentState!.validate()) {
      String nombres = _nombres.text;
      String apellidos = _apellidos.text;
      String direccion = _direccion.text;
      String civil = _civil;
      String fechaNacimiento = _dateControllernaci.text;
      String rut = _rut.text;
      String correo = _correo.text;
      String nacionalidad = _nacionalidad;
      String salud = _salud;
      String afp = _afp;
      String fechaInicio = _dateControllerini.text;
      String fechaFin = _dateControllerfina.text;
      String sueldoBase = _sueldoBase.text;
      String colacion = _colacion.text;
      String bonoAsistencia = _bonoAsistencia.text;
      String nEmpleador = _nEmpleador.text;
      String rEmpleador = _rEmpleador.text;

      // Llamada a la función para generar el contrato en formato PDF
      if (_tipoC == 'Analista Quimico' && fechaFin != 'Indefinido') {
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
            nEmpleador,
            rEmpleador);
      } else if (_tipoC == 'Analista Quimico' && fechaFin == 'Indefinido') {
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
            nEmpleador,
            rEmpleador);
      } else if (_tipoC == 'Auxiliar de Laboratorio' &&
          fechaFin != 'Indefinido') {
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
            nEmpleador,
            rEmpleador);
      } else if (_tipoC == 'Auxiliar de Laboratorio' &&
          fechaFin == 'Indefinido') {
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
            nEmpleador,
            rEmpleador);
      } else if (_tipoC == 'Tecnico Quimico' && fechaFin != 'Indefinido') {
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
            nEmpleador,
            rEmpleador);
      } else if (_tipoC == 'Tecnico Quimico' && fechaFin == 'Indefinido') {
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
            nEmpleador,
            rEmpleador);
      }
    }
  }
}
