import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class ContractService {
  Future<void> submitContract(Contract contract) async {
    Uri url = Uri.parse(
        'https://appatec-back-3c17836d3790.herokuapp.com/submit_contract');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(contract.toJson()),
      );

      if (response.statusCode == 201) {
      } else {}
    } catch (e) {}
  }

  Future<Contract?> getContractByRut(String rut) async {
    Uri url = Uri.parse(
        'https://appatec-back-3c17836d3790.herokuapp.com/get_contract_by_rut/$rut');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData != null && jsonData.isNotEmpty) {
          return Contract.fromJson(jsonData);
        }
      } else {}
    } catch (e) {}
    return null;
  }
}

class Contract {
  String fechaInicio;
  String fechaExpiracion;
  String comentario;
  String contratoUrl;
  int revisionGerente;
  int revisionGerenteGeneral;
  List<String> userIds;
  String nombres;
  String apellidos;
  String direccion;
  String estadoCivil;
  String fechaNacimiento;
  String rut;
  String mail;
  String nacionalidad;
  String sistemaSalud;
  String afp;
  String nombreEmpleador;
  String rutEmpleador;
  String cargo;
  String fechaInicioTrabajo;
  String fechaFinalTrabajo;
  int indefinido;
  String sueldoBase;
  String asignacioColacion;
  String bonoAsistencia;
  String id;
  String estado;
  int rGerente;

  Contract(
      {required this.fechaInicio,
      required this.fechaExpiracion,
      required this.comentario,
      required this.contratoUrl,
      required this.revisionGerente,
      required this.revisionGerenteGeneral,
      required this.userIds,
      required this.nombres,
      required this.apellidos,
      required this.direccion,
      required this.estadoCivil,
      required this.fechaNacimiento,
      required this.rut,
      required this.mail,
      required this.nacionalidad,
      required this.sistemaSalud,
      required this.afp,
      required this.nombreEmpleador,
      required this.rutEmpleador,
      required this.cargo,
      required this.fechaInicioTrabajo,
      required this.fechaFinalTrabajo,
      required this.indefinido,
      required this.sueldoBase,
      required this.asignacioColacion,
      required this.bonoAsistencia,
      this.id = '',
      this.estado = '',
      this.rGerente = 0});

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
        id: json['id'] as String? ?? '',
        fechaInicio: json['fecha_inicio'] as String? ?? '',
        fechaExpiracion: json['fecha_expiracion'] as String? ?? '',
        comentario: json['comentario'] as String? ?? '',
        contratoUrl: json['contrato'] as String? ?? '',
        revisionGerente: (json['revision_gerente'] as int?)?.toInt() ?? 0,
        revisionGerenteGeneral:
            (json['revision_gerente_general'] as int?)?.toInt() ?? 0,
        userIds:
            json['user_ids'] != null ? List<String>.from(json['user_ids']) : [],
        nombres: json['nombres'] as String? ?? '',
        apellidos: json['apellidos'] as String? ?? '',
        direccion: json['direccion'] as String? ?? '',
        estadoCivil: json['estado_civil'] as String? ?? '',
        fechaNacimiento: json['fecha_nacimiento'] as String? ?? '',
        rut: json['rut'] as String? ?? '',
        mail: json['mail'] as String? ?? '',
        nacionalidad: json['nacionalidad'] as String? ?? '',
        sistemaSalud: json['sistema_salud'] as String? ?? '',
        afp: json['afp'] as String? ?? '',
        nombreEmpleador: json['nombre_empleador'] as String? ?? '',
        rutEmpleador: json['rut_empleador'] as String? ?? '',
        cargo: json['cargo'] as String? ?? '',
        fechaInicioTrabajo: json['fecha_inicio'] as String? ?? '',
        fechaFinalTrabajo: json['fecha_final'] as String? ?? '',
        indefinido: json['indefinido'] as int? ?? 0,
        sueldoBase: json['sueldo_base'] as String? ?? '',
        asignacioColacion: json['asignacio_colacion'] as String? ?? '',
        bonoAsistencia: json['bono_asistencia'] as String? ?? '',
        estado: json['estado'] as String? ?? '',
        rGerente: (json['revision_gerente'] as int?)?.toInt() ?? 0);
  }

  Map<String, dynamic> toJson() => {
        'fecha_inicio': fechaInicio,
        'fecha_expiracion': fechaExpiracion,
        'comentario': comentario,
        'contrato': contratoUrl,
        'user_ids': userIds,
        'nombres': nombres,
        'apellidos': apellidos,
        'direccion': direccion,
        'estado_civil': estadoCivil,
        'fecha_nacimiento': fechaNacimiento,
        'rut': rut,
        'mail': mail,
        'nacionalidad': nacionalidad,
        'sistema_salud': sistemaSalud,
        'afp': afp,
        'nombre_empleador': nombreEmpleador,
        'rut_empleador': rutEmpleador,
        'cargo': cargo,
        'fecha_inicio_trabajo': fechaInicioTrabajo,
        'fecha_final_trabajo': fechaFinalTrabajo,
        'indefinido': indefinido,
        'sueldo_base': sueldoBase,
        'asignacio_colacion': asignacioColacion,
        'bono_asistencia': bonoAsistencia,
      };
}

void createAndSubmitContract(
    String inicio,
    String finalizacion,
    String publicUrl,
    String userId,
    String nombres,
    String apellidos,
    String direccion,
    String eCivil,
    String fNacimiento,
    String rut,
    String mail,
    String nacionalidad,
    String sSalud,
    String afp,
    String nEmpleador,
    String rEmpleadpr,
    String cargo,
    String fInicio,
    String fFinal,
    String sBase,
    String aColacion,
    String bAsistencia) {
  List<String> userIds = [userId];
  Contract newContract = Contract(
    fechaInicio: inicio,
    fechaExpiracion: finalizacion,
    comentario: "Ninguno",
    contratoUrl: publicUrl,
    revisionGerente: 0,
    revisionGerenteGeneral: 0,
    userIds: userIds,
    nombres: nombres,
    apellidos: apellidos,
    direccion: direccion,
    estadoCivil: eCivil,
    fechaNacimiento: fNacimiento,
    rut: rut,
    mail: mail,
    nacionalidad: nacionalidad,
    sistemaSalud: sSalud,
    afp: afp,
    nombreEmpleador: nEmpleador,
    rutEmpleador: rEmpleadpr,
    cargo: cargo,
    fechaInicioTrabajo: fInicio,
    fechaFinalTrabajo: fFinal,
    indefinido: 0,
    sueldoBase: sBase,
    asignacioColacion: aColacion,
    bonoAsistencia: bAsistencia,
  );

  ContractService().submitContract(newContract);
}

Future<List<Contract>> fetchContracts(String status) async {
  final response = await http.get(Uri.parse(
      'https://appatec-back-3c17836d3790.herokuapp.com/get_contracts/$status'));

  if (response.statusCode == 200) {
    List<dynamic> contractsJson = jsonDecode(response.body);
    return contractsJson.map((json) => Contract.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load contracts');
  }
}

Future<List<Contract>> fetchAllContracts(String status) async {
  final response = await http.get(Uri.parse(
      'https://appatec-back-3c17836d3790.herokuapp.com/get_contracts_all/$status'));

  if (response.statusCode == 200) {
    List<dynamic> contractsJson = jsonDecode(response.body);
    return contractsJson.map((json) => Contract.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load contracts');
  }
}

Future<List<Contract>> fetchContractsByStatuses(List<String> statuses) async {
  List<Contract> allContracts = [];
  for (String status in statuses) {
    final contracts = await fetchAllContracts(status);
    allContracts.addAll(contracts);
  }
  return allContracts;
}
