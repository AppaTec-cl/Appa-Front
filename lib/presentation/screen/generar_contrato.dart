import 'package:flutter/material.dart';
import 'package:ACG/generate/plantilla_analista_quimico.dart';
import 'package:ACG/generate/plantilla_auxiliar_laboratorio.dart';
import 'package:ACG/generate/plantilla_tecnico_quimico.dart';
import 'package:ACG/generate/plantilla_analista_quimico_indef.dart';
import 'package:ACG/generate/plantilla_auxiliar_laboratorio_indef.dart';
import 'package:ACG/generate/plantilla_tecnico_quimico_indef.dart';
import 'package:ACG/dart_rut_validator.dart';
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
String _tipoC = 'Analista Quimico';

class _GenerateContractScreenState extends State<GenerateContractScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salaryKey = GlobalKey<FormState>();
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
    ];
  }

  List<Widget> _buildWorkDetails() {
    return [
      const Text('Información Laboral',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(2),
        child: TextFormField(
          controller: _correo,
          decoration: const InputDecoration(
            labelText: 'Correo Electrónico',
            border: OutlineInputBorder(),
          ),
          validator: validateEmail, // Usa el validador de email aquí
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(3),
        child: DropdownButtonFormField<String>(
          value: _nacionalidad,
          onChanged: (value) {
            setState(() {
              _nacionalidad = value!;
            });
          },
          items: const [
            DropdownMenuItem(value: 'Chile', child: Text('Chile')),
            DropdownMenuItem(value: 'Argentina', child: Text('Argentina')),
            DropdownMenuItem(value: 'Bolivia', child: Text('Bolivia')),
            DropdownMenuItem(value: 'Perú', child: Text('Perú')),
            DropdownMenuItem(value: 'Venezuela', child: Text('Venezuela')),
            DropdownMenuItem(value: 'Colombia', child: Text('Colombia')),
            DropdownMenuItem(value: 'Camerún', child: Text('Camerún')),
          ],
          decoration: const InputDecoration(
            labelText: 'Nacionalidad',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(4),
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
        order: NumericFocusOrder(5),
        child: DropdownButtonFormField<String>(
          value: _afp,
          onChanged: (value) {
            setState(() {
              _afp = value!;
            });
          },
          items: const [
            DropdownMenuItem(value: 'ProVida', child: Text('AFP ProVida')),
            DropdownMenuItem(value: 'Modelo', child: Text('AFP Modelo')),
            DropdownMenuItem(value: 'Capital', child: Text('AFP Capital')),
            DropdownMenuItem(value: 'Cuprum', child: Text('AFP Cuprum')),
            DropdownMenuItem(value: 'Planvital', child: Text('AFP Planvital')),
            DropdownMenuItem(value: 'Habitat', child: Text('AFP Habitat')),
            DropdownMenuItem(value: 'Uno', child: Text('AFP Uno'))
          ],
          decoration: const InputDecoration(
            labelText: 'Previsión AFP',
            border: OutlineInputBorder(),
          ),
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
      FocusTraversalOrder(
        order: NumericFocusOrder(1),
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
            labelText: 'Tipo de Cargo',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(2),
        child: TextFormField(
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
                  DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES')
                      .format(date);
              _dateControllerini.text = formattedDate;
            }
          },
        ),
      ),
      const SizedBox(height: 20),
      FocusTraversalOrder(
        order: NumericFocusOrder(3),
        child: TextFormField(
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
                  DateFormat('d \'de\' MMMM \'del\' yyyy', 'es_ES')
                      .format(date);
              _dateControllerfina.text = formattedDate;
            } else {
              _dateControllerfina.text =
                  "Indefinido"; // Asigna "Indefinido" si no se selecciona una fecha
            }
          },
        ),
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
        onPressed: _isChecked && _formKey.currentState!.validate()
            ? () async {
                await generarPdf(
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
                    _rEmpleador.text);
              }
            : null,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50)),
        child: const Text('Generar Contrato'),
      ),
    ];
  }

  void _employerData(BuildContext context) {
    // Guardar los valores originales antes de abrir el diálogo
    String tempNEmpleador = _nEmpleador.text;
    String tempREmpleador = _rEmpleador.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Detalles del Empleador'),
          children: <Widget>[
            SimpleDialogOption(
              child: TextFormField(
                controller: _nEmpleador,
                decoration: const InputDecoration(
                  labelText: 'Nombre Empleador',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el nombre del empleador';
                  }
                  return null;
                },
              ),
            ),
            SimpleDialogOption(
              child: TextFormField(
                controller: _rEmpleador,
                onChanged: onChangedApplyFormat,
                decoration: const InputDecoration(
                  labelText: 'RUT Empleador',
                  border: OutlineInputBorder(),
                ),
                validator:
                    RUTValidator(validationErrorText: 'Ingrese RUT válido')
                        .validator, // Validador de RUT
              ),
            ),
            SimpleDialogOption(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Restaurar los valores originales si se cancela
                      setState(() {
                        _nEmpleador.text = tempNEmpleador;
                        _rEmpleador.text = tempREmpleador;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop();
                      }
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

  void _showSalaryDialog(BuildContext context) {
    String tempSueldoBase = _sueldoBase.text;
    String tempColacion = _colacion.text;
    String tempBonoAsistencia = _bonoAsistencia.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Detalles del Sueldo'),
          children: <Widget>[
            Form(
              key: _salaryKey,
              child: Column(
                children: [
                  SimpleDialogOption(
                    child: TextFormField(
                      controller: _sueldoBase,
                      decoration: const InputDecoration(
                        labelText: 'Sueldo Base',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el sueldo base';
                        }
                        return null;
                      },
                    ),
                  ),
                  SimpleDialogOption(
                    child: TextFormField(
                      controller: _colacion,
                      decoration: const InputDecoration(
                        labelText: 'Asignación de Colación',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese la asignación de colación';
                        }
                        return null;
                      },
                    ),
                  ),
                  SimpleDialogOption(
                    child: TextFormField(
                      controller: _bonoAsistencia,
                      decoration: const InputDecoration(
                        labelText: 'Bono de Asistencia',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el bono de asistencia';
                        }
                        return null;
                      },
                    ),
                  ),
                  SimpleDialogOption(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Restaurar los valores originales si se cancela
                            setState(() {
                              _sueldoBase.text = tempSueldoBase;
                              _colacion.text = tempColacion;
                              _bonoAsistencia.text = tempBonoAsistencia;
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String? validateEmail(String? value) {
    if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Formato de correo inválido';
    }
    return null;
  }

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
      String nEmpleador,
      String rEmpleador) async {
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
