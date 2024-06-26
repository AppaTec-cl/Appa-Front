import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnnexForm extends StatefulWidget {
  @override
  _AnnexFormState createState() => _AnnexFormState();
}

class _AnnexFormState extends State<AnnexForm> {
  String _selectedReason = 'Elegir motivo de anexo'; // Valor inicial
  bool _indefiniteContract = false;
  bool _isChecked = true;
  final TextEditingController _dateControllerFinCon = TextEditingController();

  @override
  void dispose() {
    _dateControllerFinCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar Anexo'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/img/logo.png'), // Sustituye con la ruta real de tu imagen
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            margin: const EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'RUT del trabajador (sin puntos ni guión)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Motivo',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedReason,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedReason = newValue!;
                          });
                        },
                        items: [
                          'Elegir motivo de anexo', // Asegúrate de que esta opción esté aquí
                          'Cambio de Domicilio',
                          'Cambio de Sueldo',
                          'Cambio de Area',
                          'Cambio de Horario',
                          'Traslado de Lugar De trabajo',
                          'Cambio de Tiempo de Contrato'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedReason == 'Cambio de Tiempo de Contrato') ...[
                    CheckboxListTile(
                      title: Text("Contrato Indefinido"),
                      value: _indefiniteContract,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _indefiniteContract = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      enabled: !_indefiniteContract,
                      controller: _dateControllerFinCon,
                      decoration: const InputDecoration(
                        labelText: 'Fecha Fin Contrato',
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
                          _dateControllerFinCon.text = formattedDate;
                        }
                      },
                    ),
                  ] else if (_selectedReason == 'Elegir motivo de anexo')
                    ...{}
                  else ...[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Texto 1',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Texto 2',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Anexo Generado")));
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)),
                    child: const Text('Generar Anexo'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
