import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

generarPdf(nombres, apellidos, direccion, civil, nacimiento, rut, correo,
        nacionalidad, salud, afp, inicio, finalizacion, direcciont) =>
    () async {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Contrato de Trabajo',
                      style: const pw.TextStyle(fontSize: 24),
                      textAlign: pw.TextAlign.center),
                  pw.Text(
                      'En Calama, a $inicio, entre la empresa World Survey Services S.A. (WSS), Rut. 96.947.280-5, '
                      'representado para estos efectos por don RODRIGO HERNAN ESPINOZA ASTORGA, Cédula de Identidad Nro. 14.286.378-2, '
                      'nacionalidad CHILENO ambos domiciliados en la calle José Ananías N° 651, Macul, Ciudad de Santiago, Región Metropolitana, '
                      'y otra parte don/ña $nombres $apellidos, Cédula de Identidad Nro. $rut nacionalidad $nacionalidad, nacido el $nacimiento estado civil '
                      '$civil con domicilio en $direccion, Ciudad de CALAMA, ANTOFAGASTA, correo electrónico $correo se conviene el siguiente contrato de trabajo, '
                      'para cuyos efectos las partes se denominarán empleador y trabajador respectivamente.\n\n'
                      'PRIMERO: NATURALEZA DE LOS SERVICIOS\n'
                      'El trabajador se compromete a desempeñar el cargo de: ANALISTA QUIMICO y a realizar las funciones encomendadas en el presente documento en '
                      'Laboratorio Químico división minería Calama, Ubicado en Camino Chiu Chiu #386, Sitio 45, Sector Puerto Seco, Barrio Industrial.\n\n'
                      'SEGUNDO: REMUNERACIONES\n'
                      'El empleador se compromete a remunerar los servicios del trabajador con un sueldo base imponible mensual por mes vencido en dinero efectivo, '
                      'moneda nacional, siendo proporcional a los días efectivamente trabajados, por un valor de 713.861.-\n'
                      'ASIGNACIÓN DE COLACIÓN: La Empresa pagará al Trabajador una asignación no imponible de colación por la cantidad de 80.000 Líquidos, '
                      'siendo proporcional a los días efectivos trabajados.\n'
                      'GRATIFICACIÓN: El empleador pagará mensualmente al trabajador un 25% del total de las remuneraciones mensuales, con un tope de un doceavo de '
                      '4,75 ingresos mínimos mensuales, como gratificación legal.\n'
                      'BONO DE ASISTENCIA: La empresa pagará al trabajador un bono de asistencia mensual de 80.000. Dicho bono solo será cancelado bajo las siguientes '
                      'condiciones: No debe incurrir en ninguna inasistencia injustificada en el mes; en caso de licencia médica se pagará proporcionalmente; si el trabajador '
                      'se ausenta posterior a la fecha de remuneraciones del mes en curso, se descontará el bono en el mes siguiente; No debe tener días de atraso.\n\n'
                      // Aquí seguirías agregando el resto del contrato.
                      ),
                ]);
          },
        ),
      );
      // Save the document to a file
      final String dir = (await getDownloadsDirectory())?.path ?? '';
      final String path = '$dir/contrato.pdf';
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());
    };
