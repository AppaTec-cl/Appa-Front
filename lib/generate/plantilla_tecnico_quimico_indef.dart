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

Future<void> generarPdfTecnicoQIndef(
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

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      build: (pw.Context context) => [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
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
              'En Santiago, a $inicio, entre la empresa World Survey Services S.A. (WSS), Rut. '
              '96.947.280-5, representado para estos efectos por don $nEmpleador, '
              'Cédula de Identidad Nro. $rEmpleador, ambos domiciliados en la calle José Ananías N° 651, Macul, '
              'Ciudad de Santiago, Región Metropolitana, y otra parte don/ña $nombres $apellidos, '
              'Cédula de Identidad Nro. $rut nacionalidad $nacionalidad, nacido el $nacimiento estado '
              'civil $civil con domicilio en $direccion, Ciudad de CALAMA, '
              'ANTOFAGASTA, correo electrónico $correo se conviene el siguiente contrato de trabajo, '
              'para cuyos efectos las partes se denominarán empleador y trabajador respectivamente.\n\n',
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.justify),
          pw.Text('PRIMERO: NATURALEZA DE LOS SERVICIOS\n\n',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
          pw.Text('El trabajador se compromete a:\n\n',
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.justify),
          pw.Text('Desempeñar el cargo de: TECNICO ANÁLISIS QUÍMICO\n\n',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
          pw.Text('SEGUNDO: REMUNERACIONES\n\n',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
          pw.Text(
              'El empleador se compromete a remunerar los servicios del trabajador con:\n\n',
              style: const pw.TextStyle(fontSize: 11)),
          pw.Text('SUELDO BASE: ',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          pw.Text(
              'El empleador se compromete a remunerar los servicios del trabajador con un sueldo base '
              'imponible mensual por mes vencido en dinero efectivo, moneda nacional, siendo proporcional a los días '
              'efectivamente trabajados, por un valor de \$$sueldoBase.\n\n',
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.justify),
          pw.Text('ASIGNACIÓN DE COLACIÓN: ',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          pw.Text(
              'La Empresa pagará al Trabajador una asignación no imponible de colación '
              'por la cantidad de \$$colacion Líquidos, siendo proporcional a los días efectivos trabajados.\n\n',
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.justify),
          pw.Text('GRATIFICACIÓN: ',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          pw.Text(
              'El empleador pagará mensualmente al trabajador un 25% del total de las '
              'remuneraciones mensuales, con un tope de un doceavo de 4,75 ingresos mínimos mensuales, como '
              'gratificación legal, de conformidad a lo dispuesto en el Art. 50 del Código del Trabajo -D.F.L. Nro.1 del '
              '24.01.94\n\n',
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.justify),
          pw.Text('BONO DE ASISTENCIA: ',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          pw.Text(
              'La empresa pagará al trabajador un bono de asistencia mensual de \$$bonoAsistencia.'
              '\nDicho bono solo será cancelado bajo las siguientes condiciones:\n\n',
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.justify),
          pw.Bullet(
            text:
                'No debe incurrir en ninguna inasistencia injustificada en el mes.',
            style: const pw.TextStyle(fontSize: 11),
            bulletShape: pw.BoxShape.circle, // Para un círculo sólido
            bulletSize:
                5, // Tamaño de la viñetaPersonaliza la viñeta si es necesario
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20),
            child: pw.Bullet(
              text: 'En caso de licencia médica se pagará proporcionalmente.',
              style: const pw.TextStyle(fontSize: 11),
              bulletShape: pw.BoxShape.rectangle, // Para un cuadrado sólido
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
              bulletShape: pw.BoxShape.rectangle, // Para un cuadrado sólido
              bulletSize: 5,
            ),
          ),
          pw.Bullet(
            text: 'No debe tener días de atraso. \n',
            style: const pw.TextStyle(fontSize: 11),
            bulletShape: pw.BoxShape.circle, // Para un círculo sólido
            bulletSize:
                5, // Tamaño de la viñetaPersonaliza la viñeta si es necesario
          ),
          pw.Text('\n\n\n\n\n\nFORMA DE PAGO: ',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          pw.Text(
              'El trabajador autoriza al Empleador a depositar su remuneración liquida en cuenta '
              'corriente, o en su efecto, a través de Vales Vista, Cheque, cuenta vista, dinero en efectivo o en la cuenta '
              'que a su nombre y con consentimiento contrate la empresa con alguna entidad bancaria o financiera. \n\n'
              'En caso de existir días festivos durante el turno de trabajo del trabajador que deba trabajar, la empresa '
              'pagará estos con el recargo del 50% del valor de la hora normal. \n\n'
              'El pago de la (s) remuneración (es) se hará dentro del plazo que estipula la ley, sin embargo, la empresa '
              'pagará por todos los medios a su alcance el último día hábil del mes o el día hábil anterior más próxima si '
              'este fuera sábado, domingo o festivo.\n\n',
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.justify),
          pw.Text('LEYES SOCIALES: ',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          pw.Text(
              'El empleador hará las deducciones que establecen las Leyes vigentes Art. 58 del '
              'Código del Trabajo y/o las acordadas previamente con el trabajador de las remuneraciones percibidas.\n\n'
              'Se indica además que el/la trabajador (a) cotiza en AFP $afp y $salud\n\n',
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.justify),
          pw.Text('TERCERO: LUGAR DE TRABAJO\n\n',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
          pw.Text(
              'El trabajador se compromete a realizar las funciones encomendadas en el presente documento en '
              'Laboratorio Químico división minería Calama, Ubicado en Camino Chiu Chiu #386, Sitio 45, Sector Puerto '
              'Seco, Barrio Industria\n\n',
              style: const pw.TextStyle(fontSize: 11)),
          pw.Text('CUARTO: JORNADA DE TRABAJO\n\n',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
          pw.Text('ARTICULO 22 INCISO N° 2\n\n',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          pw.Text(
              'Dada la naturaleza del cargo y de los servicios que prestara el trabajador y de conformidad a lo dispuesto '
              'en el artículo 22 del código del trabajo, el trabajador no se encontrara sujeto a jornada ordinaria o '
              'determinada de trabajo, debiendo efectuar sus mejores esfuerzos para el mejor desempeño de su cometido '
              'y el logro de los fines propuestos por el empleador al contratarlo, todos los cuales son conocidos del '
              'trabajador\n\n',
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.justify),
          pw.Text('QUINTO: OBLIGACIONES\n\n',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
        ]),
        pw.Paragraph(
            text: 'Serán obligaciones del trabajador:\n\n'
                'a) Concurrir diariamente al trabajo y dar estricto cumplimiento a la jornada.\n\n'
                'b) Desempeñar las labores que se le encomiendan, en forma fiel y eficiente, debiendo acatar las órdenes de sus jefes directos, técnicos y ejecutivos de la empresa.\n\n'
                'c) Hacer uso de los elementos de protección personal, proporcionados por la empresa, que correspondan dada la naturaleza del trabajo que se encuentre desempeñando. De acuerdo a lo estipulado en Decreto Supremo Nro. 594 que reglamenta sobre condiciones sanitarias y ambientales básicas en los lugares de trabajo; párrafo IV, art. 53.\n\n'
                'd) Dar estricto cumplimiento al reglamento interno, de seguridad y demás normas de aplicación general dentro de la empresa. (El incumplimiento de las normas de Prevención, Higiene y Seguridad, será motivo de una amonestación escrita, denominada "Anotación de Seguridad", con copia a la Inspección del Trabajo y a su Hoja de Vida Laboral. El trabajador que en el lapso de los 12 últimos meses registre tres amonestaciones, será considerado trabajador de alto riesgo de accidentabilidad).\n\n'
                'e) Mantener con el resto de los trabajadores y, en general, con todo el personal, jefes y ejecutivos de la empresa, relaciones de convivencia y respeto mutuo, que permita a cada uno el normal desempeño de sus labores.\n\n'
                'f) Acatar las instrucciones que se impartan en los medios de transporte que provea directamente la empresa o a través de terceros.\n\n'
                'g) Observar el mayor celo en el desempeño de su cargo, siendo directamente responsable ante la empresa y en conformidad a la Ley, de los actos u omisiones que cometiere, como asimismo de los perjuicios que se ocasionaren por descuido o negligencia en el cumplimiento de sus obligaciones\n\n'
                'Ordenar y cuidar los elementos de trabajo, herramientas, maquinarias, instalaciones, equipos, materiales, útiles de trabajo y elementos de protección personal que se le entreguen en el desempeño de sus labores, debiendo velar por su conservación y buen uso. El personal que tenga acceso al uso de computadores deberá utilizarlos ateniéndose estrictamente a las normas operativas que se les impartan.\n\n'
                'k) Mantener discreción y reserva de los asuntos privados y secretos de la empresa.\n\n'
                'l) Dar aviso inmediato a su Jefatura de las pérdidas, deterioros y desperfectos que sufran los equipos y objetos a su cargo.\n\n'
                'm) El trabajador, en atención a la función de conducción que cumpla para la empresa, deberá dar estricto y oportuno cumplimiento a la Ley del Tránsito, debiendo respetar en su integridad toda su normativa.\n\n'
                'ñ) Cuidar y mantener el material de trabajo, equipos, furgones, herramientas, credenciales, ropa de trabajo, y todo lo que la empresa le entregue para el desarrollo de su trabajo.\n\n'
                'o) Guardar la más absoluta reserva, respecto de todas las operaciones del empleador o de sus clientes, aunque en ellas no intervenga el trabajador.\n\n'
                'p) Las actividades de capacitación constituyen un beneficio al trabajador de manera que el trabajador se obliga a participar en ellas.\n\n'
                'q) Proporcionar a su jefe, toda la información que le sea requerida con relación a su trabajo e informarle cuando detecte anomalías en su entrono de trabajo o uso fraudulento de recursos de la empresa, en forma inmediata, precisa y fidedigna.\n\n'
                's) El trabajador que por su condición de trabajo deba mantener un: capturador de datos, Celular, Radio Portatil, Notebook, Tablet y cualquier otro equipo que le sea provisto para la ejecución de su trabajo, asignado por la empresa, deberá cuidar con máximo celo.\n\n'
                't) Cumplir con las normas, políticas, procedimientos, instrucciones, circulares y memorándum emitidos por la empresa.\n\n'
                'u) En el caso de que el trabajador tenga un consanguíneo trabajando en la empresa, este no podrá tener de dependencia directa, y el trabajador deberá informar a su superior jerárquico y a la Gerencia de Recursos Humanos, con la finalidad de removerlo a otra área.\n\n'
                'v) En el caso que un trabajador(a) tome licencia médica, el trabajador(a) faculta y autoriza a la empresa a efectuar la derivación de sus correos electrónicos para la ejecución y continuidad de los trabajos que quedaron inconclusos y la mantención de la cartera de clientes.\n\n'
                'w) Los trabajadores que se les asigna dineros a rendir para la ejecución de los trabajos conforme a sus servicios, deben rendir periódicamente y no debe ser más allá de 15 días corridos.\n\n'
                'Las infracciones a estas normas constituirán un grave incumplimiento a las obligaciones que impone el '
                'contrato de trabajo, y habilitarán al empleador para poner término al mismo. Ello, sin perjuicio de otras '
                'infracciones que importen también la terminación del contrato.\n\n',
            style: const pw.TextStyle(fontSize: 11)),
        pw.Text('SEXTO: PROHIBICIONES\n\n',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
        pw.Paragraph(
            text: 'Serán obligaciones del trabajador:\n\n'
                'Serán causales de término del presente contrato de trabajo las contenidas en los artículos 159, 160 y 161 '
                'del Código del Trabajo, y las que en el futuro se establezcan por ley, todas las cuales se dan por completa '
                'y expresamente reproducidas, entendiéndose, que forman parte integrante del presente contrato:\n\n'
                'a) Presentarse al trabajo en estado de ebriedad, ingerir bebidas alcohólicas dentro de las horas de trabajo '
                'o introducirlas al establecimiento, obra, faena o lugar de trabajo. En caso se ser sorprendido en un control '
                'el trabajador será desvinculado por esta falta grave, por incumplimiento de las obligaciones del contrato de '
                'trabajo.\n\n'
                'b) Ejecutar durante las horas de trabajo y en el desempeño de sus funciones, actividades ajenas a su '
                'labor y al establecimiento, o dedicarse a atender asuntos particulares.\n\n'
                'c) Promover o provocar juegos de azar, riñas o alteraciones de cualquier especie con sus compañeros o '
                'jefes durante la jornada de trabajo y dentro del recinto de la obra, establecimiento o faena.\n\n'
                'd) Comprar por cuenta de la empresa cualquier clase de bienes o ejecutar negociaciones con productos '
                'o bienes de la empresa sin la autorización escrita previa otorgada por la Gerencia.\n\n'
                'e) Fumar dentro de los lugares o recintos en que exista expresa prohibición para ello, de acuerdo a normas '
                'de seguridad implantadas previamente por la Gerencia.\n\n'
                'f) Vender o enajenar la ropa de trabajo o elementos de Seguridad proporcionados por la empresa.\n\n'
                'g) Negarse a trabajar, sin causa justificada en la faena o labor que se asigne o encomiende de acuerdo a '
                'lo estipulado en el contrato.\n\n'
                'h) Negarse a acatar las órdenes e instrucciones de sus jefatura(s).\n\n'
                'i) Infringir las normas de Seguridad y el Reglamento Interno de la empresa.\n\n'
                'j) Ocultar inasistencias propias o de algún otro trabajador, como asimismo, marcar o timbrar tarjetas de '
                'asistencia que no sea la propia.\n\n'
                'k) Presentarse al trabajo bajo la influencia de drogas, estimulantes y o marihuana, así también '
                'introducirlas al establecimiento, obra, faena o lugar de trabajo.\n\n'
                'l) Omitir información de su salud que le haga incompatible con el trabajo materia del presente Contrato '
                'de Trabajo.\n\n'
                'm) Producir daño al medio ambiente, ya sea por tala, quema, botar desechos o desperfectios en lugares '
                'no aptos o autorizados para hacerlo, utilizar fogatas en lugares no autorizados, realizar actividades de pesca '
                'y caza sin la autorización correspondiente.\n\n'
                'n) En el caso de los choferes, no contar con la licencia de conducir correspondiente vigente o si le es '
                'suspendida, debido que la licencia de conducir es condición esencial por la naturaleza de los servicios que '
                'presta.\n\n'
                'ñ) Omitir u ocultar información acerca de la ocurrencia de accidentes y/o incidentes laborales o mentir '
                'durante la investigación de éstos.\n\n'
                'o) Adulterar el registro de asistencia en las horas de llegada o salida del trabajo, para su beneficio o de '
                'un compañero de trabajo.\n\n'
                'p) Abandonar el trabajo sin causa justificada, ya sea dentro de la jornada ordinaria de trabajo, o de la '
                'extraordinaria previamente convenida. Asimismo, llegar atrasado al trabajo sin causa justificada.\n\n'
                'q) Dormir o descansar en los recintos de la empresa en horas de trabajo.\n\n'
                'r) Realizar paros o suspensiones de las actividades de la Empresa, bajar el ritmo de producción o actividad, '
                'o bien, promover o inducir a otros a realizar tales actos, sin sujeción a las disposiciones legales que regulan '
                'los conflictos colectivos.\n\n'
                's) El trabajador no puede realizar ninguna actividad a beneficio personal dentro del giro específico de la '
                'empresa y/o de las empresas a las que se les están prestando “los servicios”, lo cual queda expresamente '
                'prohibido.\n\n'
                't) El trabajador se obliga a mantener absoluta reserva respecto de los procedimientos, métodos de trabajo '
                'y utilización de sistemas y técnicas de control de calidad, como asimismo respecto de los proyectos o '
                'programas de trabajo de la empresa. De igual modo deberá mantener esta reserva, en la eventualidad de '
                'alejarse de la empresa, por un período de 2 años.\n\n'
                'u) Portar armas.\n\n'
                'v) Robar o hurtar bienes de la empresa, de sus trabajadores o de terceros.\n\n'
                'w) Participar en riñas o agresiones con o a cualquier persona, sea que dicha persona pertenezca a la '
                'empresa o sea una persona externa a ella.\n\n'
                'x) Se prohíbe utilizar redes sociales durante la jornada de trabajo cuando así la jefatura lo prohíba, tales '
                'como: Whatsapp, Facebook, Twitter, entre otras. En caso de conducción, está estrictamente prohibido.\n\n'
                'y) Cobrar o recibir propinas de cualquier especie, regalos o compensaciones de cualquier tipo por parte '
                'del mandante y/o clientes.\n\n'
                'z) No utilizar, modificar o adulterar los elementos de protección personal proporcionados por el '
                'empleador para la realización de los trabajos encomendados.\n\n'
                'aa) Modificar o adulterar el GPS del vehículo y GPS móvil proporcionado por la empresa para la '
                'ejecución de los trabajos encomendados.\n\n'
                'bb) Cometer en el desempeño de sus labores, cualquier tipo de actos que puedan ser calificados por el '
                'empleador o por cualquiera de las empresas a las cuales este último presta servicios como falta de probidad.\n\n'
                'cc) Publicar o mal utilizar la información recopilada en terreno como fotografías, videos u otros medios '
                'o formatos utilizados, en ocasión del trabajo.\n\n'
                'dd) El incumplimiento en la entrega de los trabajos encomendados en lo que dice relación al plazo pactado '
                'y al cumplimiento cabal de éste, es decir, no se aceptarán entregas con atrasos, trabajos no hechos, trabajos '
                'mal ejecutados, adulteración o falsa información. Excesos de errores y en general, cualquier otra '
                'irregularidad o anomalía que signifique que el trabajador no ha cumplido con la labor encomendada, y que '
                'traigan como consecuencia una sanción económica al empleador por parte de la empresa mandante.\n\n'
                'ee) El trabajador acepta reintegrar los montos que por concepto, de multas le sean aplicados al '
                'empleador, cuando sea probado que su desempeño irresponsable, ha traído como consecuencia, el perjuicio '
                'pecuniario y/o ponga en peligro la estabilidad contractual de la empresa y de sus compañeros de trabajo, '
                'en cuyo caso, el trabajador acepta que el empleador le descuente en forma mensual de su liquidación de '
                'sueldo el monto que por este concepto, asuma la empresa. Del mismo modo, tratándose de vehículos que '
                'la empresa ponga a disposición del trabajador, este último deberá responder, por los daños ocasionados a '
                'los vehículos o con el pago correspondiente al valor del deducible que la empresa de seguros aplique cuando '
                'las causas del siniestro sean por uso indebido o imputable al trabajador.\n\n'
                'ff) Será causal de desvinculación por incumplimiento grave a las obligaciones que impone el contrato, en '
                'la eventualidad de sorprender al trabajador alterando o cambiando resultados y/o los procedimientos de '
                'calidad establecidos para el desarrollo de su trabajo establecido, sin autorización de la empresa en la '
                'actualización escrita de estos procedimientos.\n\n'
                'gg) Se prohíbe al trabajador vender los pasajes que la empresa proporciona a terceras personas, en '
                'donde compra para su traslado, ya sea para concurrir a su trabajo o para devolverse de su trabajo.\n\n'
                'hh) Se prohíbe utilizar redes sociales durante la jornada de trabajo, si por condiciones laborales de '
                'seguridad, orden de su jefatura o del área de prevención de riesgo así lo indican, tales como: WhatsApp, en '
                'el caso de otras, como: Facebook, Twitter, entre otras, están estrictamente prohibidas.\n\n'
                'La transgresión a estas prohibiciones, será considerada como falta grave para las obligaciones que le '
                'impone su contrato de trabajo.\n\n',
            style: const pw.TextStyle(fontSize: 11)),
        pw.Text('SEPTIMO: CONDICIONES DE TRABAJO\n\n',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
        pw.Paragraph(
            text:
                'El trabajador declara tener la salud compatible con el tipo de trabajo que deberá desempeñar de acuerdo '
                'al presente Contrato de Trabajo. Declara, además, haber tomado conocimiento de los riesgos involucrados en el trabajo a ejecutar.\n\n',
            style: const pw.TextStyle(fontSize: 11)),
        pw.Text('OCTAVO: ASPECTOS LEGALES\n\n',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
        pw.Paragraph(
            text:
                'Para todos los efectos legales derivados del presente contrato de trabajo, las partes fijan domicilio en la ciudad de Santiago.\n\n',
            style: const pw.TextStyle(fontSize: 11)),
        pw.Text('NOVENO: DURACIÓN\n\n',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
        pw.Paragraph(
            text:
                'Se deja expresamente constancia de que el trabajador ingresa al servicio de la empresa el $inicio y que la duración del presente contrato será indefinido.\n\n'
                'Se deja expresamente establecido que las partes aceptan como condición esencial para la vigencia del '
                'presente contrato de trabajo que el empleador mantenga su calidad de contratista o subcontratista de la '
                'mencionada obra (faena).\n\n'
                'En consecuencia, el empleador suscribe el presente contrato sobre la base de ser y mantener la calidad de '
                'contratista o subcontratista antes referida y, mientras mantenga tal calidad, de suerte que si por cualquier '
                'causa, circunstancia o motivo, cese o expire tal calidad, se entiende en forma expresa que igual suerte corre '
                'el presente contrato de trabajo, situación ésta que es plena y cabalmente aceptada por el trabajador.\n\n'
                'Además, las partes convienen que la conclusión del presente contrato de trabajo se producirá al momento '
                'de concluir sus servicios específicos conforme el avance de las obras, según lo determine la empresa, dada '
                'la necesidad de separar paulatinamente al personal, al paso y medida que va concluyendo la respectiva '
                'faena y demandando menor mano de obra.\n\n',
            style: const pw.TextStyle(fontSize: 11)),
        pw.Text('DECIMO: CONSTANCIA\n\n',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
        pw.Paragraph(
            text:
                'Declaro bajo juramento que toda la información que he entregado a mi empleador respecto de mis '
                'antecedentes personales y calificaciones técnicas es fidedigna y que no he señalado nada que no '
                'corresponda a la verdad, así como tampoco he presentado documentos o certificados adulterados o '
                'inexactos. Asumo que la decisión en cuanto a mi contratación ha tenido por fundamento la veracidad de los '
                'antecedentes proporcionados por el suscrito, por lo que estoy en pleno conocimiento que la falsedad en mis '
                'actuales declaraciones o los antecedentes proporcionados será siempre un grave atentado a la probidad y '
                'la buena fe por mi parte en el contexto del contrato.\n\n',
            style: const pw.TextStyle(fontSize: 11)),
        pw.Text(
            'DECIMO PRIMERO: RECEPCION DE CÓDIGO DE ÉTICA Y EL REGLAMENTO INTERNO DE LA EMPRESA\n\n',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
        pw.Paragraph(
            text:
                'El trabajador declara haber recibido el Código de Ética y el Reglamento Interno de la Empresa, los cuales '
                'forman parte integra del contrato de trabajo para todos los efectos legales, elevando las partes a la categoría '
                'de incumplimiento grave a las infracciones a cualquiera de las disposiciones, las cuales el Trabajador declara '
                'conocer, comprender y aceptar.\n\n',
            style: const pw.TextStyle(fontSize: 11)),
        pw.Text('DECIMO SEGUNDO: EJEMPLARES\n\n',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
        pw.Paragraph(
            text:
                'El presente contrato se firma en 3 ejemplares, declarando el trabajador haber recibido en este acto a su '
                'entera satisfacción un ejemplar de él y que este es fiel reflejo de la relación laboral entre las partes, declara, '
                'además, recibir conjuntamente con la copia del contrato, una copia del Reglamento Interno de la empresa.\n\n',
            style: const pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 40), // Espacio antes de la sección de firmas
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
  );

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
            'Tecnico Quimico',
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
