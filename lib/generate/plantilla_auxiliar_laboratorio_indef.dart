import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:googleapis/storage/v1.dart' as storage;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:googleapis_auth/auth_io.dart';
import 'package:ACG/endpoint/config.dart';
import 'package:ACG/endpoint/contract.dart';

Future<void> uploadFileToGoogleCloud(String filePath) async {
  var client = await CloudStorageConfig.getClient();
  var bucketName = 'almacenamiento_pdf';
  var fileToUpload = File(filePath);
  var media = storage.Media(fileToUpload.openRead(), fileToUpload.lengthSync());
  var destination = 'contratos/${fileToUpload.uri.pathSegments.last}';

  try {
    var insertRequest = storage.Object()
      ..bucket = bucketName
      ..name = destination;

    await storage.StorageApi(client)
        .objects
        .insert(insertRequest, bucketName, uploadMedia: media);
    print('Archivo cargado con éxito a Google Cloud Storage');
  } catch (e) {
    print('Error al cargar el archivo: $e');
  } finally {
    client.close();
  }
}

Future<Uint8List> loadAsset(String path) async {
  final ByteData data = await rootBundle.load(path);
  return data.buffer.asUint8List();
}

Future<void> generarPdfAuxiliarLIndef(
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
    sueldoBase,
    colacion,
    bonoAsistencia,
    nEmpleador,
    rEmpleador) async {
  final pdf = pw.Document();

  final watermarkData = await loadAsset('assets/img/logo.png');
  final image = pw.MemoryImage(watermarkData);

  pw.PageTheme pageTheme = pw.PageTheme(
    buildBackground: (pw.Context context) {
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.Positioned(
          child: pw.Opacity(
            opacity: 0.7, // Adjust opacity for your watermark
            child: pw.Image(image, width: 100, height: 50),
          ),
          top: 1, // Adjust position accordingly
          right: 1, // Adjust position accordingly
        ),
      );
    },
  );

  pdf.addPage(pw.MultiPage(
      pageTheme: pageTheme,
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
                    'En Santiago, a $inicio, entre la empresa WORLD SURVEY SERVICES S.A. (WSS), Rut. '
                    '96.947.280-5, representado para estos efectos por don $nEmpleador, '
                    'Cédula de Identidad Nro. $rEmpleador, ambos domiciliados en la calle JOSÉ ANANÍAS N° 651, MACUL, '
                    'Ciudad de SANTIAGO, REGION METROPOLITANA, con correo electrónico corporativo wss@wss.cl y '
                    'otra parte don/ña $nombres $apellidos, Cédula de Identidad Nro. '
                    '$rut, nacionalidad $nacionalidad nacida el $nacimiento estado civil $civil, con domicilio en '
                    '$direccion, Ciudad de CALAMA región de ANTOFAGASTA, correo electrónico '
                    '$correo se conviene el siguiente contrato de trabajo, para cuyos efectos las partes se '
                    'denominarán empleador y trabajador respectivamente.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('PRIMERO: NATURALEZA DE LOS SERVICIOS\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text('El trabajador se compromete a:\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('Desempeñar el cargo de: AUXILIAR DE LABORATORIO\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(
                    'Para la División Minería de WSS, unidad Calama, ubicada en sitio 45 camino a Chiu Chiu, Barrio Industrial, '
                    'Calama. Obligándose a ejecutar las labores a cabalidad indicadas en su Descriptor de Cargo, las cuales son '
                    'inherentes y complementarias a lo que se indica en el artículo 12 del código del trabajo.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('SEGUNDO: REMUNERACIONES\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text(
                    'El empleador se compromete a remunerar los servicios del trabajador con:\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('SUELDO BASE: ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(
                    'El empleador se compromete a remunerar los servicios del trabajador con un sueldo base '
                    'imponible mensual por mes vencido en dinero efectivo, moneda nacional, siendo proporcional a los días '
                    'efectivamente trabajados, por un valor de $sueldoBase.-\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('BONO ASISTENCIA: ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(
                    'La empresa pagará al trabajador un bono de asistencia mensual de \$$bonoAsistencia.- '
                    'imponible. Dicho bono solo será cancelado bajo las siguientes condiciones:\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    '       No debe incurrir en ninguna inasistencia en el mes en curso.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    '       No debe incurrir en ningún atraso injustificado en el mes en curso.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'En caso de que el trabajador presentase una inasistencia o atraso injustificado posterior al pago del mes en '
                    'curso, el bono será descontado en las remuneraciones del mes siguiente.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'En caso de licencia médica el bono será cancelado en forma proporcional, a los días efectivamente '
                    'trabajados.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('ASIGNACIÓN DE COLACIÓN: ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(
                    'La Empresa pagará al Trabajador una asignación de colación por la '
                    'cantidad de \$$colacion.- Líquidos, siendo proporcional a los días efectivos trabajados.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('GRATIFICACIÓN: ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(
                    'El empleador pagará mensualmente al trabajador un 25% del total de las '
                    'remuneraciones mensuales, con un tope de un doceavo de 4,75 ingresos mínimos mensuales, como '
                    'gratificación legal, de conformidad a lo dispuesto en el Art. 50 del Código del Trabajo -D.F.L. Nro.1 del '
                    '24.01.94\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('FORMA DE PAGO: ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(
                    'El trabajador autoriza al Empleador a depositar su remuneración liquida en cuenta '
                    'corriente, o en su efecto, en la cuenta que a su nombre y con consentimiento del trabajador contrate la '
                    'empresa con alguna entidad bancaria o financiera, sin que esto signifique costo alguno para el trabajador.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'El pago de la (s) remuneración (es) se hará dentro del plazo que estipula la ley, sin embargo, la empresa '
                    'pagará por todos los medios a su alcance el día 27 de cada mes, o el día hábil anterior si este fuera '
                    'sábado domingo o festivo.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('HORAS EXTRAS: ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(
                    'En caso de existir horas extras durante el turno de trabajo, la empresa pagará '
                    'estos con el recargo del 50% del valor de la hora normal.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'IMPUESTOS: En caso que la remuneración del Trabajador exceda las 13,5 UTM, el empleador '
                    'tendrá la obligación de responder por el pago del impuesto a la renta correspondiente en relación '
                    'con la remuneración pagada, no pudiendo ser descontado del monto líquido acordado.\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text('LEYES SOCIALES:\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(
                    'El empleador hará las deducciones que establecen las Leyes vigentes Art. 58 del Código del Trabajo y/o las '
                    'acordadas previamente con el trabajador de las remuneraciones percibidas.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'Se deja constancia que el trabajador cotizará en el régimen previsional chileno, comprometiéndose el '
                    'empleador a efectuar las retenciones y entregarlas a las instituciones correspondientes.\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(
                    'Según lo indicado por el Trabajador este cotiza en AFP $afp y $salud.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('TERCERO: LUGAR DE TRABAJO\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text(
                    'El trabajador dependiendo de las necesidades del servicio se compromete a efectuar los trabajos '
                    'encomendados en: Laboratorio Calama WSS, Juan Nicolás Zaldívar, Sitio 15 Puerto Seco, Barrio Industrial '
                    'Ciudad de Calama.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'CUARTO: JORNADA DE TRABAJO JORNADA EXCEPCIONAL 7 X 7 Y 8 X 6\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text(
                    'Por mutuo acuerdo de las partes, trabajador efectuará una jornada de trabajo comprendida en: 7 días '
                    'continuos de labores seguido de 7 días continuos de descanso, en horario diurno, con una jornada diaria '
                    'de 12 horas y un tiempo de colación de 1 hora imputable a dicha jornada, distribuida de 09:00 a 21:00 '
                    'horas y otro ciclo de trabajo que se compone de 8 días continuos de labores, seguido de 6 días continuos '
                    'de descanso, en horario nocturno, con una jornada diaria de 12 horas y un tiempo de colación de 1 hora '
                    'imputable a dicha jornada, distribuida de 21:00 a 9:00 horas.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('QUINTO: OBLIGACIONES\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text('Serán obligaciones del trabajador:\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Bullet(
                    text:
                        'Concurrir diariamente al trabajo y dar estricto cumplimiento a la jornada.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Desempeñar las labores que se le encomiendan, en forma fiel y eficiente, debiendo acatar las órdenes '
                        'de sus jefes directos, técnicos y ejecutivos de la empresa.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Hacer uso de los elementos de protección personal, proporcionados por la empresa, que '
                        'correspondan dada la naturaleza del trabajo que se encuentre desempeñando. De acuerdo a lo '
                        'estipulado en Decreto Supremo Nro. 594 que reglamenta sobre condiciones sanitarias y '
                        'ambientales básicas en los lugares de trabajo; párrafo IV, art. 53.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Dar estricto cumplimiento al reglamento interno, de seguridad y demás normas de aplicación '
                        'general dentro de la empresa. (El incumplimiento de las normas de Prevención, Higiene y '
                        'Seguridad, será motivo de una amonestación escrita, denominada \"Anotación de Seguridad\", con '
                        'copia a la Inspección del Trabajo y a su Hoja de Vida Laboral. El trabajador que en el lapso de los '
                        '12 últimos meses registre tres amonestaciones, será considerado trabajador de alto riesgo de '
                        'accidentabilidad).\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Mantener con el resto de los trabajadores y, en general, con todo el personal, jefes y ejecutivos de '
                        'la empresa, relaciones de convivencia y respeto mutuo, que permita a cada uno el normal '
                        'desempeño de sus labores.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Acatar las instrucciones que se impartan en los medios de transporte que provea directamente la '
                        'empresa o a través de terceros.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Observar el mayor celo en el desempeño de su cargo, siendo directamente responsable ante la '
                        'Empresa y en conformidad a la Ley, de los actos u omisiones que cometiere, como asimismo de '
                        'los perjuicios que se ocasionaren por descuido o negligencia en el cumplimiento de sus '
                        'obligaciones.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Dar aviso dentro de un plazo de 24 horas al Supervisor directo, o a la Gerencia de Recursos '
                        'Humanos, en caso de inasistencia por enfermedad u otra causa que le impida concurrir '
                        'transitoriamente a su trabajo. Para los casos de aviso por enfermedad, el trabajador deberá '
                        'presentar la respectiva licencia médica dentro de las 48 horas hábiles siguientes, y en casos de '
                        'otras circunstancias, la respectiva documentación para su justificación. La empresa se reserva el '
                        'derecho de justificar o no la inasistencia.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Cuidar de su aseo y presentación personal y de la higiene del lugar donde presta sus servicios y '
                        'su entorno.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Ordenar y cuidar los elementos de trabajo, herramientas, maquinarias, instalaciones, equipos, '
                        'materiales, útiles de trabajo y elementos de protección personal que se le entreguen en el '
                        'desempeño de sus labores, debiendo velar por su conservación y buen uso. El personal que tenga '
                        'acceso al uso de computadores deberá utilizarlos ateniéndose estrictamente a las normas '
                        'operativas que se les impartan.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Mantener discreción y reserva de los asuntos privados y secretos de la empresa.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Dar aviso inmediato a su Jefatura de las pérdidas, deterioros y desperfectos que sufran los '
                        'equipos y objetos a su cargo.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'El trabajador, en atención a la función de conducción que cumpla para la empresa, deberá dar '
                        'estricto y oportuno cumplimiento a la Ley del Tránsito, debiendo respetar en su integridad toda su '
                        'normativa. Por lo anterior, las infracciones en que incurra a la referida ley, que sean producto de '
                        'su actuar, ya sea, por acción o por omisión, serán de la exclusiva responsabilidad del trabajador, '
                        'asumiendo el deber de liberar a la empresa de tales infracciones y en el caso que ellas ocurran, '
                        'resarcir los gastos en que incurra por tal concepto. Por lo tanto, en los casos que la empresa deba '
                        'concurrir al pago de multas o sanciones por infracción a las normas del tránsito, que se deriven de '
                        'la responsabilidad del trabajador, éste asume del deber de reembolsar a la empresa tales gastos, '
                        'para lo cual, en este acto y por el presente instrumento autoriza expresamente a su empleador '
                        'para que descuente de su remuneración mensual el monto de la multa y, en el caso que dicho '
                        'monto supere el límite legal, el descuento se realizará en el mes o meses siguientes hasta el pago '
                        'de tal cantidad. En el evento que el contrato termine por cualquier causa y quedare un monto '
                        'pendiente de restitución, será descontado de los haberes que proceda pagar en el finiquito, para lo '
                        'cual, el trabajador concede expresa autorización.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'En general, cumplir con todas las obligaciones que emanan de su condición de trabajador, las que imponen '
                        'el presente contrato y la legislación vigente.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Cuidar y mantener el material de trabajo, equipos, furgones, herramientas, credenciales, ropa de '
                        'trabajo, y todo lo que la empresa le entregue para el desarrollo de su trabajo. Respecto de la ropa '
                        'de trabajo, ésta será proporcionada por el empleador de conformidad a las necesidades del '
                        'trabajo efectuado por el trabajador y definidas por el área de prevención de riesgo.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Guardar la más absoluta reserva, respecto de todas las operaciones del empleador o de sus '
                        'clientes, aunque en ellas no intervenga el trabajador.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Las actividades de capacitación constituyen un beneficio al trabajador de manera que el trabajador '
                        'se obliga a participar en ellas, y estará determinada por la oportunidad en que se realicen esas '
                        'actividades. Así, si la actividad o acción se realiza dentro de la jornada de trabajo el trabajador o '
                        'durante el descanso del trabajador, este último se compromete a concurrir a esa acción o '
                        'actividad. Esta última no es jornada de trabajo, ni corresponde ser remunerado, y porque el '
                        'descanso no ha sido subordinado por el legislador a condición alguna. De esta manera, las '
                        'acciones o actividades de capacitación programadas por la empresa durante el descanso semanal '
                        'de sus dependientes, no constituye jornada de trabajo.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Proporcionar a su jefe, toda la información que le sea requerida con relación a su trabajo e '
                        'informarle cuando detecte anomalías en su entrono de trabajo o uso fraudulento de recursos de la '
                        'empresa, en forma inmediata, precisa y fidedigna.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Informar de Inmediato a la empresa cuando por una imposibilidad física, u otra causa justificada, '
                        'no pueda continuar con el trabajo asignado, por enfermedad, sin perjuicio de la obligación que le '
                        'asiste de acreditar su enfermedad mediante una licencia médica presentada dentro de los plazos '
                        'legales establecidos.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'El trabajador que por su condición de trabajo deba mantener un: capturador de datos, Celular, '
                        'Radio Portatil, Notebook, Tablet y cualquier otro equipo que le sea provisto para la ejecución de su '
                        'trabajo, asignado por la empresa y que son necesarios para que el trabajador pueda llevar a cabo '
                        'su trabajo deberá cuidarlos con máximo celo. Está prohibido ingresar sin autorización o sacar '
                        'equipos personales (notebook, cámaras fotográficas, etc) de y a la faena, los cuales de ser '
                        'sorprendidos podrán ser requisados por el departamento de seguridad del lugar hasta su revisión '
                        'y autorización de ingreso/retiro.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Cumplir con las normas, políticas, procedimientos, instrucciones, circulares y memorándum '
                        'emitidos por la empresa.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'En el caso de que el trabajador tenga un consanguíneo trabajando en la empresa, este no podrá '
                        'tener de dependencia directa, y el trabajador deberá informar a su superior jerárquico y a la '
                        'Gerencia de Recursos Humanos, con la finalidad de removerlo a otra área. En el caso de ofertar '
                        'un puesto de trabajo a un consanguíneo para postular algún puesto en la empresa, este siempre '
                        'deberá ser a un área distinta a la que pertenece.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'En el caso que un trabajador(a) tome licencia médica, el trabajador(a) faculta y autoriza a la '
                        'empresa a efectuar la derivación de sus correos electrónicos para la ejecución y continuidad de '
                        'los trabajos que quedaron inconclusos y la mantención de la cartera de clientes.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Los trabajadores que se les asigna dineros a rendir para la ejecución de los trabajos conforme a '
                        'sus servicios, deben rendir periódicamente y no debe ser más allá de 15 días corridos.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Text(
                    'Las infracciones a estas normas constituirán un grave incumplimiento a las obligaciones que impone el '
                    'contrato de trabajo, y habilitarán al empleador para poner término al mismo. Ello, sin perjuicio de otras '
                    'infracciones que importen también la terminación del contrato.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('SEXTO: PROHIBICIONES\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text(
                    'Serán causales de término del presente contrato de trabajo las contenidas en los artículos 159, 160 y 161 '
                    'del Código del Trabajo, y las que en el futuro se establezcan por ley, todas las cuales se dan por completa '
                    'y expresamente reproducidas, entendiéndose, que forman parte integrante del presente contrato:\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Bullet(
                    text:
                        'Presentarse al trabajo en estado de ebriedad o bajo los efectos de cualquier droga, ingerir '
                        'bebidas alcohólicas dentro de las horas de trabajo o introducirlas al establecimiento, obra, faena '
                        'o lugar de trabajo. En caso se ser sorprendido en un control el trabajador podrá ser desvinculado '
                        'por esta falta grave, por incumplimiento de las obligaciones del contrato de trabajo.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Ejecutar durante las horas de trabajo y en el desempeño de sus funciones, actividades ajenas a '
                        'su labor y al establecimiento, o dedicarse a atender asuntos particulares.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Promover o provocar juegos de azar, riñas o alteraciones de cualquier especie con sus compañeros o '
                        'jefes durante la jornada de trabajo y dentro del recinto de la obra, establecimiento o faena.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Comprar por cuenta de la empresa cualquier clase de bienes o ejecutar negociaciones con '
                        'productos o bienes de la empresa sin la autorización escrita previa otorgada por la Gerencia.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Fumar dentro de los lugares o recintos en que exista expresa prohibición para ello, de acuerdo a '
                        'normas de seguridad implantadas previamente por la Gerencia.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Vender o enajenar la ropa de trabajo o elementos de Seguridad proporcionados por la empresa.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Negarse a trabajar, sin causa justificada en la faena o labor que se asigne o encomiende de '
                        'acuerdo a lo estipulado en el contrato y según lo indicado en su Descriptor de Cargo.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Negarse a acatar las órdenes e instrucciones de sus jefatura (s).\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Negarse a acatar las órdenes e instrucciones de sus jefatura (s).\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Infringir las normas de Seguridad y el Reglamento Interno de la empresa.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Ocultar inasistencias propias o de algún otro trabajador, como asimismo, marcar o timbrar '
                        'tarjetas de asistencia que no sea la propia.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Omitir información de su salud que le haga incompatible con el trabajo materia del presente '
                        'Contrato de Trabajo.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Producir daño al medio ambiente, ya sea por tala, quema, botar desechos o desperdicios en '
                        'lugares no aptos o autorizados para hacerlo, utilizar fogatas en lugares no autorizados, realizar '
                        'actividades de pesca y caza sin la autorización correspondiente.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'En el caso de los choferes, no contar con la licencia de conducir correspondiente vigente o si le '
                        'es suspendida, debido que la licencia de conducir es condición esencial por la naturaleza de los '
                        'servicios que presta.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Adulterar el registro de asistencia en las horas de llegada o salida del trabajo, para su beneficio o '
                        'de un compañero de trabajo.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Abandonar el trabajo sin causa justificada, ya sea dentro de la jornada ordinaria de trabajo, o de la '
                        'extraordinaria previamente convenida. Asimismo, llegar atrasado al trabajo sin causa justificada.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Dormir o descansar en los recintos de la empresa en horas de trabajo.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Realizar paros o suspensiones de las actividades de la Empresa, bajar el ritmo de producción o '
                        'actividad, o bien, promover o inducir a otros a realizar tales actos, sin sujeción a las '
                        'disposiciones legales que regulan los conflictos colectivos.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'El trabajador no puede realizar ninguna actividad a beneficio personal dentro del giro específico '
                        'de la empresa y/o de las empresas a las que se les están prestando \"los servicios\", lo cual queda '
                        'expresamente prohibido.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'El trabajador se obliga a mantener absoluta reserva respecto de los procedimientos, métodos de '
                        'trabajo y utilización de sistemas y técnicas de control de calidad, como asimismo respecto de los '
                        'proyectos o programas de trabajo de la empresa. De igual modo deberá mantener esta reserva, '
                        'en la eventualidad de alejarse de la empresa, por un período de 2 años.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text: 'Portar armas.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Robar o hurtar bienes de la empresa, de sus trabajadores o de terceros.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Participar en riñas o agresiones con o a cualquier persona, sea que dicha persona pertenezca a '
                        'la empresa o sea una persona externa a ella.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Cobrar o recibir propinas de cualquier especie, regalos o compensaciones de cualquier tipo por '
                        'parte del mandante y/o clientes.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'No utilizar, modificar o adulterar los elementos de protección personal proporcionados por el '
                        'empleador para la realización de los trabajos encomendados.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Modificar o adulterar el GPS del vehículo y GPS móvil proporcionado por la empresa para la '
                        'ejecución de los trabajos encomendados.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Cometer en el desempeño de sus labores, cualquier tipo de actos que puedan ser calificados por '
                        'el empleador o por cualquiera de las empresas a las cuales este último presta servicios como '
                        'falta de probidad.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Publicar o mal utilizar la información recopilada en terreno como fotografías, videos u otros '
                        'medios formatos utilizados, en ocasión del trabajo.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'El incumplimiento en la entrega de los trabajos encomendados en lo que dice relación al plazo '
                        'pactado y al cumplimiento cabal de éste, es decir, no se aceptarán entregas con atrasos, '
                        'trabajos no hechos, trabajos mal ejecutados, adulteración o falsa información. Excesos de '
                        'errores y en general, cualquier otra irregularidad o anomalía que signifique que el trabajador no '
                        'ha cumplido con la labor encomendada, y que traigan como consecuencia una sanción '
                        'económica al empleador por parte de la empresa mandante.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'El trabajador acepta reintegrar los montos que por concepto, de multas le sean aplicados al '
                        'empleador, cuando sea probado que su desempeño irresponsable, ha traído como '
                        'consecuencia, el perjuicio pecuniario y/o ponga en peligro la estabilidad contractual de la '
                        'empresa y de sus compañeros de trabajo, en cuyo caso, el trabajador acepta que el empleador '
                        'le descuente en forma mensual de su liquidación de sueldo el monto que por este concepto, '
                        'asuma la empresa. Del mismo modo, tratándose de vehículos que la empresa ponga a '
                        'disposición del trabajador, este último deberá responder, por los daños ocasionados a los '
                        'vehículos o con el pago correspondiente al valor del deducible que la empresa de seguros '
                        'aplique cuando las causas del siniestro sean por uso indebido o imputable al trabajador.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Será causal de desvinculación por incumplimiento grave a las obligaciones que impone el '
                        'contrato, en la eventualidad de sorprender al trabajador alterando o cambiando resultados y/o los '
                        'procedimientos de calidad establecidos para el desarrollo de su trabajo establecido, sin '
                        'autorización de la empresa en la actualización escrita de estos procedimientos.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Se prohíbe al trabajador vender los pasajes que la empresa proporciona a terceras persona, en '
                        'donde compra para su traslado, ya sea para concurrir a su trabajo o para devolverse de su '
                        'trabajo.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Bullet(
                    text:
                        'Se prohíbe utilizar redes sociales durante la jornada de trabajo, si por condiciones laborales de '
                        'seguridad, orden de su jefatura o del área de prevención de riesgo así lo indican, tales como: '
                        'WhatsApp, en el caso de otras, como: Facebook, Twitter, entre otras, están estrictamente '
                        'prohibidas.\n',
                    style: const pw.TextStyle(fontSize: 11),
                    bulletShape: pw.BoxShape.circle,
                    bulletSize: 5),
                pw.Text(
                    'La transgresión a estas prohibiciones, será considerada como falta grave para las obligaciones que le '
                    'impone su contrato de trabajo.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('SEPTIMO: CONDICIONES DE TRABAJO\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text(
                    'El trabajador declara tener la salud compatible con el tipo de trabajo que deberá desempeñar de acuerdo '
                    'al presente Contrato de Trabajo.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'Declara, además, haber tomado conocimiento de los riesgos involucrados en el trabajo.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('OCTAVO: ASPECTOS LEGALES\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text(
                    'Para todos los efectos legales derivados del presente contrato de trabajo, las partes fijan domicilio en la '
                    'ciudad de Santiago.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('NOVENO: INICIO Y DURACION DEL CONTRATO\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text(
                    'Se deja expresa constancia de que el trabajador ingresa al servicio de la empresa el $inicio y que la '
                    'duración del presente contrato será indefinido.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'La obligación de prestar servicios emanada del presente contrato, sólo podrá cumplirse una vez '
                    'una vez que el trabajador haya obtenido la visación de residencia correspondiente en Chile o el '
                    'permiso especial de trabajo para extranjeros con visa en trámite, sin embargo, el contrato de igual '
                    'podrá terminar por las causales argumentadas en el código del trabajo.\n\n',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                      fontStyle: pw.FontStyle.italic,
                    )),
                pw.Text(
                    'Se deja expresamente establecido que las partes aceptan como condición esencial para la vigencia del '
                    'presente contrato de trabajo que el empleador mantenga su calidad de contratista o subcontratista de la '
                    'mencionada obra (faena).\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'En consecuencia, el empleador suscribe el presente contrato sobre la base de ser y mantener la calidad '
                    'de contratista o subcontratista antes referida y, mientras mantenga tal calidad, de suerte que si por '
                    'cualquier causa, circunstancia o motivo, cese o expire tal calidad, se entiende en forma expresa que igual '
                    'suerte corre el presente contrato de trabajo, situación ésta que es plena y cabalmente aceptada por el '
                    'trabajador.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'Además, las partes convienen que la conclusión del presente contrato de trabajo se producirá al momento '
                    'de concluir sus servicios específicos conforme el avance de las obras, según lo determine la empresa, '
                    'dada la necesidad de separar paulatinamente al personal, al paso y medida que va concluyendo la '
                    'respectiva faena y demandando menor mano de obra.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('DECIMO: CONSTANCIA\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text(
                    'Declaro bajo juramento que toda la información que he entregado a mi empleador respecto de mis '
                    'antecedentes personales y calificaciones técnicas es fidedigna y que no he señalado nada que no '
                    'corresponda a la verdad, así como tampoco he presentado documentos o certificados adulterados o '
                    'inexactos. Asumo que la decisión en cuanto a mi contratación ha tenido por fundamento la veracidad de '
                    'los antecedentes proporcionados por el suscrito, por lo que estoy en pleno conocimiento que la falsedad '
                    'en mis actuales declaraciones o los antecedentes proporcionados será siempre un grave atentado a la '
                    'probidad y la buena fe por mi parte en el contexto del contrato.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text(
                    'DECIMO PRIMERO: RECEPCION DE CÓDIGO DE ÉTICA Y EL REGLAMENTO INTERNO DE LA EMPRESA\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text(
                    'El trabajador declara haber recibido el Código de Ética y el Reglamento Interno de la Empresa, los cuales '
                    'forman parte integra del contrato de trabajo para todos los efectos legales, elevando las partes a la '
                    'categoría de incumplimiento grave a las infracciones a cualquiera de las disposiciones, las cuales el '
                    'Trabajador declara conocer, comprender y aceptar.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.Text('DECIMO SEGUNDO: EJEMPLARES\n\n',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Text(
                    'El presente contrato se firma en 3 ejemplares, declarando el trabajador haber recibido en este acto a su '
                    'entera satisfacción un ejemplar de él y que este es fiel reflejo de la relación laboral entre las partes, '
                    'declara, además, recibir conjuntamente con la copia del contrato, una copia del Reglamento Interno de la '
                    'empresa.\n\n',
                    style: const pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.justify),
                pw.SizedBox(
                    height: 40), // Espacio antes de la sección de firmas
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 150,
                          child: pw.Divider(),
                        ),
                        pw.Text('World Survey Services S.A. (WSS)'),
                        pw.Text('RUT: 96947280-5'),
                        pw.Text('Empresa'),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 150,
                          child: pw.Divider(),
                        ),
                        pw.Text('$nombres'),
                        pw.Text('RUT: $rut'),
                        pw.Text('Trabajador'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ]));

  String ensurePdfExtension(String fileName) {
    // Asegurarse de que el nombre del archivo termina con '.pdf'
    if (!fileName.toLowerCase().endsWith('.pdf')) {
      fileName += '.pdf'; // Agregar la extensión .pdf si no está presente
    }
    return fileName;
  }

  Future<void> manageFileUpload(String nombres) async {
    String initialFileName = 'Contrato $nombres'; // Nombre inicial del archivo
    String? filePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Elige donde desea guardar su contrato',
      fileName: initialFileName,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (filePath != null) {
      File file = File(filePath);
      String correctedFileName = ensurePdfExtension(file.uri.pathSegments.last);

      // Asegúrate de que el archivo guardado localmente tiene la extensión .pdf
      String correctedFilePath = file.parent.path + '/' + correctedFileName;
      File correctedFile = File(correctedFilePath);

      // Escribir los bytes del PDF en el nuevo archivo con la extensión asegurada
      await correctedFile.writeAsBytes(await pdf.save());

      // Subir el archivo con el nombre corregido a Google Cloud Storage
      await uploadFileToGoogleCloud(correctedFilePath);
      var publicUrl =
          'https://storage.googleapis.com/almacenamiento_pdf/contratos/$correctedFileName';

      Future<String> getCurrentUserId() async {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString('userId') ?? 'default_user_id';
      }

      void initiateContractCreation(
          inicio,
          finalizacion,
          publicUrl,
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
          nEmpleador,
          rEmpleador,
          sueldoBase,
          colacion,
          bonoAsistencia) async {
        String userId = await getCurrentUserId(); // Recupera el ID del usuario
        createAndSubmitContract(
            inicio,
            finalizacion,
            publicUrl,
            userId,
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
            nEmpleador,
            rEmpleador,
            'Auxiliar Laboratorio',
            inicio,
            finalizacion,
            sueldoBase,
            colacion,
            bonoAsistencia);
      }

      initiateContractCreation(
          inicio,
          "indefinido",
          publicUrl,
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
          nEmpleador,
          rEmpleador,
          sueldoBase,
          colacion,
          bonoAsistencia);
    }
  }

  manageFileUpload(nombres);
}
