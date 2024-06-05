import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

generarPdf(
        nombres,
        apellidos,
        direccion,
        civil,
        nacimiento,
        rut,
        correo,
        nacionalidad,
        salud,
        afp,
        inicio,
        finalizacion,
        sueldoBase,
        colacion,
        bonoAsistencia) =>
    () async {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
            build: (pw.Context context) => [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Center(
                          child: pw.Text(
                            'Contrato de Trabajo \n\n',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Text(
                            'En Calama, a $inicio, entre la empresa World Survey Services S.A. (WSS), Rut. 96.947.280-5, '
                            'representado para estos efectos por don RODRIGO HERNAN ESPINOZA ASTORGA, Cédula de Identidad Nro. 14.286.378-2, '
                            'nacionalidad CHILENO ambos domiciliados en la calle José Ananías N° 651, Macul, Ciudad de Santiago, Región Metropolitana, '
                            'y otra parte don/ña $nombres $apellidos, Cédula de Identidad Nro. $rut nacionalidad $nacionalidad, nacido el $nacimiento estado civil '
                            '$civil con domicilio en $direccion, Ciudad de CALAMA, ANTOFAGASTA, correo electrónico $correo se conviene el siguiente contrato de trabajo, '
                            'para cuyos efectos las partes se denominarán empleador y trabajador respectivamente.\n\n',
                            style: const pw.TextStyle(fontSize: 11),
                            textAlign: pw.TextAlign.justify),
                        pw.Text('PRIMERO: NATURALEZA DE LOS SERVICIOS\n',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 13)),
                        pw.Text(
                            'El trabajador se compromete a desempeñar el cargo de: ANALISTA QUIMICO y a realizar las funciones encomendadas en el presente documento en '
                            'Laboratorio Químico división minería Calama, Ubicado en Camino Chiu Chiu #386, Sitio 45, Sector Puerto Seco, Barrio Industrial.\n\n',
                            style: const pw.TextStyle(fontSize: 11),
                            textAlign: pw.TextAlign.justify),
                        pw.Text('SEGUNDO: REMUNERACIONES\n',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 13)),
                        pw.Text(
                            'El empleador se compromete a remunerar los servicios del trabajador con:\n\n',
                            style: const pw.TextStyle(fontSize: 11)),
                        pw.Text('SUELDO BASE: \n',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 11)),
                        pw.Text(
                            'El empleador se compromete a remunerar los servicios del trabajador con un sueldo base '
                            'imponible mensual por mes vencido en dinero efectivo, moneda nacional, siendo proporcional a los días '
                            'efectivamente trabajados, por un valor de \$$sueldoBase.',
                            style: const pw.TextStyle(fontSize: 11),
                            textAlign: pw.TextAlign.justify),
                        pw.Text('\nASIGNACIÓN DE COLACIÓN: \n',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 11)),
                        pw.Text(
                            'La Empresa pagará al Trabajador una asignación no imponible de colación '
                            'por la cantidad de \$$colacion Líquidos, siendo proporcional a los días efectivos trabajados.',
                            style: const pw.TextStyle(fontSize: 11),
                            textAlign: pw.TextAlign.justify),
                        pw.Text('\nGRATIFICACIÓN: \n',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 11)),
                        pw.Text(
                            'El empleador pagará mensualmente al trabajador un 25% del total de las '
                            'remuneraciones mensuales, con un tope de un doceavo de 4,75 ingresos mínimos mensuales, como '
                            'gratificación legal, de conformidad a lo dispuesto en el Art. 50 del Código del Trabajo -D.F.L. Nro.1 del '
                            '24.01.94',
                            style: const pw.TextStyle(fontSize: 11),
                            textAlign: pw.TextAlign.justify),
                        pw.Text('\nBONO DE ASISTENCIA: \n',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 11)),
                        pw.Text(
                            'La empresa pagará al trabajador un bono de asistencia mensual de \$$bonoAsistencia.'
                            '\nDicho bono solo será cancelado bajo las siguientes condiciones:\n\n',
                            style: const pw.TextStyle(fontSize: 11),
                            textAlign: pw.TextAlign.justify),
                        pw.Bullet(
                          text:
                              'No debe incurrir en ninguna inasistencia injustificada en el mes.',
                          style: const pw.TextStyle(fontSize: 11),
                          bulletShape:
                              pw.BoxShape.circle, // Para un círculo sólido
                          bulletSize:
                              7, // Tamaño de la viñetaPersonaliza la viñeta si es necesario
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 20),
                          child: pw.Bullet(
                            text:
                                'En caso de licencia médica se pagará proporcionalmente.',
                            style: const pw.TextStyle(fontSize: 11),
                            bulletShape: pw
                                .BoxShape.rectangle, // Para un cuadrado sólido
                            bulletSize: 5,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 20),
                          child: pw.Bullet(
                            text:
                                'Si el trabajador se ausenta posterior a la fecha de remuneraciones del mes en '
                                'curso, se descontará el bono en el mes siguiente.',
                            style: const pw.TextStyle(fontSize: 11),
                            bulletShape: pw
                                .BoxShape.rectangle, // Para un cuadrado sólido
                            bulletSize: 5,
                          ),
                        ),
                        pw.Bullet(
                          text: 'No debe tener días de atraso.',
                          style: const pw.TextStyle(fontSize: 11),
                          bulletShape:
                              pw.BoxShape.circle, // Para un círculo sólido
                          bulletSize:
                              7, // Tamaño de la viñetaPersonaliza la viñeta si es necesario
                        ),
                        pw.Text('\nFORMA DE PAGO: \n',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 11)),
                        pw.Text(
                            'El trabajador autoriza al Empleador a depositar su remuneración liquida en cuenta '
                            'corriente, o en su efecto, a través de Vales Vista, Cheque, cuenta vista, dinero en efectivo o en la cuenta '
                            'que a su nombre y con consentimiento contrate la empresa con alguna entidad bancaria o financiera. \n\n'
                            'En caso de existir días festivos durante el turno de trabajo del trabajador que deba trabajar, la empresa '
                            'pagará estos con el recargo del 50% del valor de la hora normal. \n\n'
                            'El pago de la (s) remuneración (es) se hará dentro del plazo que estipula la ley, sin embargo, la empresa '
                            'pagará por todos los medios a su alcance el último día hábil del mes o el día hábil anterior más próxima si '
                            'este fuera sábado, domingo o festivo.',
                            style: const pw.TextStyle(fontSize: 11),
                            textAlign: pw.TextAlign.justify),
                      ])
                ]),
      );
      // Save the document to a file
      final String dir = (await getDownloadsDirectory())?.path ?? '';
      final String path = '$dir/contrato.pdf';
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());
    };
