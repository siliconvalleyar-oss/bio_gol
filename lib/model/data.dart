import 'package:flutter/painting.dart';

class Situacion {
  final int id;
  final String texto;
  final String estimulo;
  final String receptor;
  final String procesamiento;
  final String respuesta;
  final String efector;

  const Situacion({
    required this.id, required this.texto,
    required this.estimulo, required this.receptor,
    required this.procesamiento, required this.respuesta,
    required this.efector,
  });

  static const List<Situacion> lista = [
    Situacion(id:1,texto:"El árbitro hace sonar el silbato y el jugador comienza a correr.",estimulo:"Sonido del silbato",receptor:"Oído",procesamiento:"Cerebro",respuesta:"Comenzar a correr",efector:"Músculos de las piernas"),
    Situacion(id:2,texto:"Un arquero ve que la pelota se dirige hacia el arco.",estimulo:"Movimiento de la pelota",receptor:"Ojos",procesamiento:"Cerebro",respuesta:"Lanzarse",efector:"Músculos de brazos y piernas"),
    Situacion(id:3,texto:"Un jugador escucha a un compañero pedir un pase.",estimulo:"Voz del compañero",receptor:"Oído",procesamiento:"Cerebro",respuesta:"Realizar el pase",efector:"Músculos de las piernas"),
    Situacion(id:4,texto:"La pelota golpea inesperadamente la pierna de un jugador.",estimulo:"Contacto de la pelota",receptor:"Receptores táctiles (piel)",procesamiento:"Sistema nervioso",respuesta:"Retirar la pierna",efector:"Músculos de la pierna"),
    Situacion(id:5,texto:"Un jugador observa una tarjeta amarilla mostrada por el árbitro.",estimulo:"Tarjeta amarilla (visual)",receptor:"Ojos",procesamiento:"Cerebro",respuesta:"Detener la discusión",efector:"Músculos corporales"),
    Situacion(id:6,texto:"Un defensor ve acercarse un rival con la pelota.",estimulo:"Movimiento del rival",receptor:"Ojos",procesamiento:"Cerebro",respuesta:"Interceptar",efector:"Músculos de las piernas"),
    Situacion(id:7,texto:"El entrenador grita una indicación desde el banco.",estimulo:"Voz del entrenador",receptor:"Oído",procesamiento:"Cerebro",respuesta:"Cambiar de posición",efector:"Músculos de las piernas"),
    Situacion(id:8,texto:"Un jugador siente una gota de lluvia en el rostro.",estimulo:"Contacto de la lluvia",receptor:"Piel",procesamiento:"Cerebro",respuesta:"Parpadear o limpiarse",efector:"Músculos faciales"),
    Situacion(id:9,texto:"Un delantero ve el arco libre.",estimulo:"Visión del arco",receptor:"Ojos",procesamiento:"Cerebro",respuesta:"Patear",efector:"Músculos de la pierna"),
    Situacion(id:10,texto:"El público comienza a cantar fuertemente.",estimulo:"Sonido de la hinchada",receptor:"Oído",procesamiento:"Cerebro",respuesta:"Prestar atención",efector:"Músculos de cabeza y ojos"),
    Situacion(id:11,texto:"Un jugador recibe una pelota alta.",estimulo:"Aproximación de la pelota",receptor:"Ojos",procesamiento:"Cerebro",respuesta:"Cabecear",efector:"Músculos del cuello"),
    Situacion(id:12,texto:"Una luz intensa ilumina el estadio.",estimulo:"Luz intensa",receptor:"Ojos",procesamiento:"Cerebro",respuesta:"Cerrar parcialmente los ojos",efector:"Músculos de los párpados"),
    Situacion(id:13,texto:"Un jugador siente dolor por una caída.",estimulo:"Golpe",receptor:"Nociceptores (dolor)",procesamiento:"Cerebro",respuesta:"Tocar la zona afectada",efector:"Músculos del brazo"),
    Situacion(id:14,texto:"El árbitro señala un penal.",estimulo:"Gesto del árbitro (visual)",receptor:"Ojos",procesamiento:"Cerebro",respuesta:"Prepararse para ejecutar",efector:"Músculos corporales"),
    Situacion(id:15,texto:"Un jugador percibe olor a humo cerca del estadio.",estimulo:"Humo (olor)",receptor:"Nariz",procesamiento:"Cerebro",respuesta:"Buscar el origen",efector:"Músculos de cabeza y ojos"),
    Situacion(id:16,texto:"El arquero observa el movimiento del pie del pateador.",estimulo:"Movimiento del pie",receptor:"Ojos",procesamiento:"Cerebro",respuesta:"Lanzarse hacia un lado",efector:"Músculos de brazos y piernas"),
    Situacion(id:17,texto:"Un jugador toca una botella con agua fría.",estimulo:"Temperatura fría",receptor:"Termorreceptores de la piel",procesamiento:"Cerebro",respuesta:"Sostenerla o retirar la mano",efector:"Músculos del brazo"),
    Situacion(id:18,texto:"El juez de línea levanta la bandera.",estimulo:"Visión de la bandera",receptor:"Ojos",procesamiento:"Cerebro",respuesta:"Detener la jugada",efector:"Músculos de las piernas"),
    Situacion(id:19,texto:"Un jugador escucha el final del partido.",estimulo:"Silbato final",receptor:"Oído",procesamiento:"Cerebro",respuesta:"Dejar de jugar",efector:"Músculos corporales"),
    Situacion(id:20,texto:"Un compañero levanta la mano pidiendo el balón.",estimulo:"Señal visual",receptor:"Ojos",procesamiento:"Cerebro",respuesta:"Pasar la pelota",efector:"Músculos de la pierna"),
  ];
}

class PreguntaTrivia {
  final String texto;
  final bool correcta;
  const PreguntaTrivia({required this.texto, required this.correcta});
  static const List<PreguntaTrivia> lista = [
    PreguntaTrivia(texto:"Cuando un arquero ve venir una pelota, sus ojos actúan como receptores.", correcta:true),
    PreguntaTrivia(texto:"El cerebro no participa en la toma de decisiones durante un partido.", correcta:false),
    PreguntaTrivia(texto:"El silbato del árbitro es un estímulo sonoro.", correcta:true),
    PreguntaTrivia(texto:"Los músculos son efectores porque realizan la respuesta.", correcta:true),
    PreguntaTrivia(texto:"Los receptores táctiles se encuentran solamente en las manos.", correcta:false),
    PreguntaTrivia(texto:"Un jugador puede responder a varios estímulos al mismo tiempo.", correcta:true),
    PreguntaTrivia(texto:"Las neuronas transportan información en el sistema nervioso.", correcta:true),
    PreguntaTrivia(texto:"El oído detecta estímulos luminosos.", correcta:false),
    PreguntaTrivia(texto:"El tiempo de reacción influye en el rendimiento deportivo.", correcta:true),
    PreguntaTrivia(texto:"El cerebro procesa la información recibida por los sentidos.", correcta:true),
    PreguntaTrivia(texto:"El contacto de una pelota con la pierna es un estímulo táctil.", correcta:true),
    PreguntaTrivia(texto:"Los reflejos son respuestas voluntarias y planificadas.", correcta:false),
    PreguntaTrivia(texto:"La médula espinal forma parte del sistema nervioso central.", correcta:true),
    PreguntaTrivia(texto:"El ojo es un órgano receptor de estímulos visuales.", correcta:true),
    PreguntaTrivia(texto:"Los músculos no participan en las respuestas corporales.", correcta:false),
    PreguntaTrivia(texto:"Un jugador puede reaccionar ante una luz o un sonido.", correcta:true),
    PreguntaTrivia(texto:"La información nerviosa viaja a través de neuronas.", correcta:true),
    PreguntaTrivia(texto:"Los receptores reciben estímulos del medio interno y externo.", correcta:true),
    PreguntaTrivia(texto:"El sistema nervioso coordina las respuestas del organismo.", correcta:true),
    PreguntaTrivia(texto:"El arquero no utiliza sus sentidos durante un penal.", correcta:false),
    PreguntaTrivia(texto:"El sistema nervioso periférico conecta el cerebro con los músculos del futbolista.", correcta:true),
    PreguntaTrivia(texto:"La visión periférica permite al jugador ver el arco sin mirarlo directamente.", correcta:true),
    PreguntaTrivia(texto:"El olor del césped recién cortado no puede ser detectado por los receptores olfativos.", correcta:false),
    PreguntaTrivia(texto:"El equilibrio durante un regate depende del sistema vestibular del oído interno.", correcta:true),
    PreguntaTrivia(texto:"Los receptores de dolor (nociceptores) avisan al jugador cuando sufre una falta.", correcta:true),
    PreguntaTrivia(texto:"El cerebro puede procesar hasta 11 millones de bits de información por segundo durante un partido.", correcta:true),
    PreguntaTrivia(texto:"La propiocepción permite al futbolista saber dónde tiene sus pies sin mirarlos.", correcta:true),
    PreguntaTrivia(texto:"El sistema nervioso autónomo regula la respiración mientras el jugador corre.", correcta:true),
    PreguntaTrivia(texto:"La sinapsis es el espacio entre dos neuronas por donde viaja la información.", correcta:true),
    PreguntaTrivia(texto:"El lóbulo occipital del cerebro se encarga de procesar los sonidos del estadio.", correcta:false),
    PreguntaTrivia(texto:"La médula espinal puede generar respuestas reflejas sin intervención del cerebro.", correcta:true),
    PreguntaTrivia(texto:"El calor del sol en la piel es detectado por termorreceptores cutáneos.", correcta:true),
    PreguntaTrivia(texto:"Un jugador con lesión en el cerebelo tendría dificultades para coordinar sus movimientos.", correcta:true),
    PreguntaTrivia(texto:"Las hormonas del estrés como la adrenalina mejoran la atención del futbolista.", correcta:true),
    PreguntaTrivia(texto:"El arco reflejo involucra únicamente al cerebro como centro procesador.", correcta:false),
    PreguntaTrivia(texto:"La memoria muscular permite ejecutar un tiro libre sin pensar conscientemente.", correcta:true),
    PreguntaTrivia(texto:"El nervio óptico transporta la imagen de la pelota desde el ojo hasta el cerebro.", correcta:true),
    PreguntaTrivia(texto:"La fatiga mental en un partido alargado afecta la velocidad de procesamiento neuronal.", correcta:true),
    PreguntaTrivia(texto:"La corteza motora planifica el movimiento antes de patear la pelota.", correcta:true),
    PreguntaTrivia(texto:"El sistema nervioso central está formado por el cerebro y la médula espinal.", correcta:true),
    PreguntaTrivia(texto:"La pupila se dilata cuando hay poca luz en el estadio.", correcta:true),
    PreguntaTrivia(texto:"Los reflejos del arquero son más rápidos que los movimientos voluntarios.", correcta:true),
    PreguntaTrivia(texto:"El olfato no tiene ninguna función en el fútbol.", correcta:false),
    PreguntaTrivia(texto:"Las neuronas motoras llevan órdenes desde el cerebro hasta los músculos.", correcta:true),
    PreguntaTrivia(texto:"El lóbulo frontal participa en la estrategia de juego.", correcta:true),
    PreguntaTrivia(texto:"Los termorreceptores permiten sentir la temperatura del pasto.", correcta:true),
    PreguntaTrivia(texto:"El cerebelo coordina el equilibrio al gambetear.", correcta:true),
    PreguntaTrivia(texto:"Los cinco sentidos actúan al mismo tiempo durante un partido.", correcta:true),
    PreguntaTrivia(texto:"El sistema nervioso simpático acelera el corazón antes de un penal.", correcta:true),
    PreguntaTrivia(texto:"Los receptores kinestésicos informan la posición del cuerpo en el campo.", correcta:true),
    PreguntaTrivia(texto:"El nervio auditivo lleva el sonido del silbato hasta el cerebro.", correcta:true),
    PreguntaTrivia(texto:"La memoria a corto plazo ayuda a recordar tácticas durante el partido.", correcta:true),
    PreguntaTrivia(texto:"Los reflejos condicionados se aprenden con la práctica deportiva.", correcta:true),
    PreguntaTrivia(texto:"La saliva se produce como reflejo al oler comida en el estadio.", correcta:true),
    PreguntaTrivia(texto:"La corteza visual procesa las jugadas que el futbolista ve.", correcta:true),
    PreguntaTrivia(texto:"El sistema límbico regula las emociones al hacer un gol.", correcta:true),
    PreguntaTrivia(texto:"Las neuronas sensoriales llevan información desde los receptores hasta el cerebro.", correcta:true),
    PreguntaTrivia(texto:"El hipotálamo regula la temperatura corporal durante el ejercicio.", correcta:true),
    PreguntaTrivia(texto:"Los corpúsculos de Pacini detectan presión en la planta del pie.", correcta:true),
    PreguntaTrivia(texto:"El nervio ciático transmite señales desde la médula hasta la pierna del futbolista.", correcta:true),
    PreguntaTrivia(texto:"El sistema nervioso entérico controla la digestión mientras el jugador corre.", correcta:true),
    PreguntaTrivia(texto:"La sinapsis química usa neurotransmisores para pasar la información.", correcta:true),
    PreguntaTrivia(texto:"El tiempo de reacción visual es más lento que el tiempo de reacción auditivo.", correcta:true),
  ];

  static const List<PreguntaTrivia> demo = [
    PreguntaTrivia(texto:"Los ojos sirven para ver la pelota.", correcta:true),
    PreguntaTrivia(texto:"El cerebro ayuda a pensar.", correcta:true),
    PreguntaTrivia(texto:"Los oídos sirven para oler.", correcta:false),
    PreguntaTrivia(texto:"La nariz sirve para oler.", correcta:true),
    PreguntaTrivia(texto:"Los músculos sirven para patear la pelota.", correcta:true),
    PreguntaTrivia(texto:"La piel sirve para escuchar.", correcta:false),
    PreguntaTrivia(texto:"El sol es caliente y se siente en la piel.", correcta:true),
    PreguntaTrivia(texto:"Un gol se festeja con los brazos.", correcta:true),
    PreguntaTrivia(texto:"El silbato del árbitro se escucha con los ojos.", correcta:false),
    PreguntaTrivia(texto:"Cuando corrés, el corazón late más rápido.", correcta:true),
  ];
}

class EstacionSensorial {
  final String icono;
  final String nombre;
  final String descripcion;
  final String estimulo;
  final String receptor;
  const EstacionSensorial({required this.icono, required this.nombre, required this.descripcion, required this.estimulo, required this.receptor});
  static const List<EstacionSensorial> lista = [
    EstacionSensorial(icono:"🔊", nombre:"Sonido", descripcion:"Escuchá el sonido → levantá la mano.", estimulo:"Sonoro", receptor:"Oído"),
    EstacionSensorial(icono:"💡", nombre:"Luz", descripcion:"Vé la luz → da un paso adelante.", estimulo:"Visual", receptor:"Ojos"),
    EstacionSensorial(icono:"✋", nombre:"Tacto", descripcion:"Sentí el toque → girá 90°.", estimulo:"Táctil", receptor:"Piel"),
    EstacionSensorial(icono:"👁️", nombre:"Visual", descripcion:"Vé el objeto caer → atrápalo.", estimulo:"Visual", receptor:"Ojos"),
    EstacionSensorial(icono:"👃", nombre:"Olfato", descripcion:"Olé el aroma → identificá el olor.", estimulo:"Olfativo", receptor:"Nariz"),
  ];
}

class InfoModelo {
  final String icono;
  final String titulo;
  final String descripcion;
  final Color color;
  const InfoModelo({required this.icono, required this.titulo, required this.descripcion, required this.color});
  static const List<InfoModelo> pasos = [
    InfoModelo(icono:"⚡", titulo:"Estímulo", descripcion:"Cualquier cambio en el ambiente que puede ser detectado. En el fútbol: la pelota que se acerca, el silbato, un grito.", color:Color(0xFFE53935)),
    InfoModelo(icono:"👁️", titulo:"Receptor", descripcion:"Estructura especializada que capta el estímulo. Ojos (luz), oídos (sonido), piel (tacto), nariz (olor), lengua (gusto).", color:Color(0xFFFB8C00)),
    InfoModelo(icono:"🧠", titulo:"Procesamiento", descripcion:"El sistema nervioso (cerebro + médula) analiza la información y decide qué hacer. Ocurre en milisegundos.", color:Color(0xFF1565C0)),
    InfoModelo(icono:"💪", titulo:"Efector", descripcion:"El músculo o glándula que ejecuta la orden. En el fútbol: los músculos de las piernas, brazos, cuello.", color:Color(0xFF43A047)),
    InfoModelo(icono:"⚽", titulo:"Respuesta", descripcion:"La acción final. Correr, saltar, patear, lanzarse. El resultado visible del procesamiento.", color:Color(0xFF7B1FA2)),
  ];
}

class Usuario {
  final String id;
  String nombre;
  String edad;
  String alias;
  String pais;
  String email;
  String telefono;
  int puntos;
  int aciertos;
  int racha;
  int rachaMax;
  int reaccionPromedio;
  int colorTestPuntos;
  int sonidoTestPuntos;
  int paisTestPuntos;
  String fecha;

  Usuario({
    String? id,
    this.nombre = '', this.edad = '', this.alias = '', this.pais = '',
    this.email = '', this.telefono = '',
    this.puntos = 0, this.aciertos = 0, this.racha = 0, this.rachaMax = 0,
    this.reaccionPromedio = 0, this.colorTestPuntos = 0, this.sonidoTestPuntos = 0,
    this.paisTestPuntos = 0, String? fecha,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      fecha = fecha ?? DateTime.now().toIso8601String();

  int get puntosTotales => puntos + colorTestPuntos + sonidoTestPuntos + paisTestPuntos;

  bool get triviaCompletada => puntos > 0;
  bool get reaccionCompletado => reaccionPromedio > 0;
  bool get colorTestCompletado => colorTestPuntos > 0;
  bool get sonidoTestCompletado => sonidoTestPuntos > 0;
  bool get paisTestCompletado => paisTestPuntos > 0;

  bool get esCustomPais => pais.startsWith('CUSTOM:');

  String get paisDisplay {
    if (esCustomPais) {
      final parts = pais.split(':');
      return parts.length > 1 ? parts[1] : 'Personalizado';
    }
    return pais;
  }

  List<Color>? get customPaisColores {
    if (!esCustomPais) return null;
    final parts = pais.split(':');
    final n = parts.length - 2;
    if (n < 1) return null;
    final colores = <Color>[];
    for (int i = 2; i < parts.length; i++) {
      final val = int.tryParse(parts[i].replaceFirst('#', ''), radix: 16);
      if (val != null) colores.add(Color(val));
    }
    return colores.isEmpty ? null : colores;
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'nombre': nombre, 'edad': edad, 'alias': alias, 'pais': pais,
    'email': email, 'telefono': telefono,
    'puntos': puntos, 'aciertos': aciertos, 'racha': racha,
    'rachaMax': rachaMax, 'reaccionPromedio': reaccionPromedio,
    'colorTestPuntos': colorTestPuntos, 'sonidoTestPuntos': sonidoTestPuntos,
    'paisTestPuntos': paisTestPuntos, 'fecha': fecha,
  };

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json['id'] as String?,
    nombre: json['nombre'] as String? ?? '',
    edad: json['edad'] as String? ?? '',
    alias: json['alias'] as String? ?? '',
    pais: json['pais'] as String? ?? '',
    email: json['email'] as String? ?? '',
    telefono: json['telefono'] as String? ?? '',
    puntos: json['puntos'] as int? ?? 0,
    aciertos: json['aciertos'] as int? ?? 0,
    racha: json['racha'] as int? ?? 0,
    rachaMax: json['rachaMax'] as int? ?? 0,
    reaccionPromedio: json['reaccionPromedio'] as int? ?? 0,
    colorTestPuntos: json['colorTestPuntos'] as int? ?? 0,
    sonidoTestPuntos: json['sonidoTestPuntos'] as int? ?? 0,
    paisTestPuntos: json['paisTestPuntos'] as int? ?? 0,
    fecha: json['fecha'] as String?,
  );
}

class PaisInfo {
  final String flag;
  final String nombre;
  const PaisInfo(this.flag, this.nombre);

  static const List<PaisInfo> lista = [
    PaisInfo('🇦🇷', 'Argentina'),
    PaisInfo('🇧🇷', 'Brasil'),
    PaisInfo('🇺🇾', 'Uruguay'),
    PaisInfo('🇵🇾', 'Paraguay'),
    PaisInfo('🇨🇱', 'Chile'),
    PaisInfo('🇧🇴', 'Bolivia'),
    PaisInfo('🇵🇪', 'Perú'),
    PaisInfo('🇪🇨', 'Ecuador'),
    PaisInfo('🇨🇴', 'Colombia'),
    PaisInfo('🇻🇪', 'Venezuela'),
    PaisInfo('🇬🇾', 'Guyana'),
    PaisInfo('🇸🇷', 'Surinam'),
    PaisInfo('🇵🇦', 'Panamá'),
    PaisInfo('🇨🇷', 'Costa Rica'),
    PaisInfo('🇳🇮', 'Nicaragua'),
    PaisInfo('🇭🇳', 'Honduras'),
    PaisInfo('🇸🇻', 'El Salvador'),
    PaisInfo('🇬🇹', 'Guatemala'),
    PaisInfo('🇲🇽', 'México'),
    PaisInfo('🇨🇺', 'Cuba'),
    PaisInfo('🇩🇴', 'República Dominicana'),
    PaisInfo('🇭🇹', 'Haití'),
    PaisInfo('🇨🇦', 'Canadá'),
    PaisInfo('🇺🇸', 'Estados Unidos'),
    PaisInfo('🇫🇷', 'Francia'),
    PaisInfo('🇩🇪', 'Alemania'),
    PaisInfo('🇮🇹', 'Italia'),
    PaisInfo('🏴󠁧󠁢󠁥󠁮󠁧󠁿', 'Inglaterra'),
    PaisInfo('🇵🇹', 'Portugal'),
    PaisInfo('🇳🇱', 'Países Bajos'),
    PaisInfo('🇪🇸', 'España'),
    PaisInfo('🇧🇪', 'Bélgica'),
    PaisInfo('🇭🇷', 'Croacia'),
    PaisInfo('🇷🇸', 'Serbia'),
    PaisInfo('🇨🇭', 'Suiza'),
    PaisInfo('🇸🇪', 'Suecia'),
    PaisInfo('🇩🇰', 'Dinamarca'),
    PaisInfo('🇳🇴', 'Noruega'),
    PaisInfo('🇵🇱', 'Polonia'),
    PaisInfo('🇺🇦', 'Ucrania'),
    PaisInfo('🇷🇺', 'Rusia'),
    PaisInfo('🇨🇳', 'China'),
    PaisInfo('🇯🇵', 'Japón'),
    PaisInfo('🇰🇷', 'Corea del Sur'),
    PaisInfo('🇮🇷', 'Irán'),
    PaisInfo('🇸🇦', 'Arabia Saudita'),
    PaisInfo('🇦🇺', 'Australia'),
    PaisInfo('🇰🇪', 'Kenia'),
    PaisInfo('🇳🇬', 'Nigeria'),
    PaisInfo('🇸🇳', 'Senegal'),
    PaisInfo('🇲🇦', 'Marruecos'),
    PaisInfo('🇩🇿', 'Argelia'),
    PaisInfo('🇪🇬', 'Egipto'),
    PaisInfo('🇿🇦', 'Sudáfrica'),
    PaisInfo('🇬🇭', 'Ghana'),
    PaisInfo('🇨🇲', 'Camerún'),
    PaisInfo('🇨🇮', 'Costa de Marfil'),
    PaisInfo('🇹🇳', 'Túnez'),
    PaisInfo('🏴󠁧󠁢󠁷󠁬󠁳󠁿', 'Gales'),
    PaisInfo('🏴󠁧󠁢󠁳󠁣󠁴󠁿', 'Escocia'),
    PaisInfo('🇮🇪', 'Irlanda'),
    PaisInfo('🇹🇷', 'Turquía'),
    PaisInfo('🇦🇹', 'Austria'),
    PaisInfo('🇭🇺', 'Hungría'),
    PaisInfo('🇷🇴', 'Rumania'),
    PaisInfo('🇧🇬', 'Bulgaria'),
    PaisInfo('🇬🇷', 'Grecia'),
    PaisInfo('🇮🇳', 'India'),
    PaisInfo('🇸🇬', 'Singapur'),
    PaisInfo('🇲🇾', 'Malasia'),
    PaisInfo('🇮🇩', 'Indonesia'),
    PaisInfo('🇵🇭', 'Filipinas'),
    PaisInfo('🇳🇿', 'Nueva Zelanda'),
  ];
}

class AppState {
  int puntos;
  int aciertos;
  int racha;
  int triviaIdx;
  int triviaCorrectas;
  int triviaIncorrectas;
  bool triviaAnswered;
  List<bool> sensorialDone;
  String notas;
  List<Usuario> historial;
  String paletaId;
  double fontSize;
  List<String> audioMap;
  int usuarioIdx;
  Usuario? usuarioActivo;

  AppState({
    this.puntos = 0, this.aciertos = 0, this.racha = 0,
    this.triviaIdx = 0, this.triviaCorrectas = 0, this.triviaIncorrectas = 0,
    this.triviaAnswered = false,
    List<bool>? sensorialDone, this.notas = '',
    List<Usuario>? historial, this.paletaId = 'default',
    this.fontSize = 24, List<String>? audioMap, this.usuarioIdx = -1,
    this.usuarioActivo,
  }) : sensorialDone = sensorialDone ?? [false,false,false,false,false],
      historial = historial ?? [],
      audioMap = audioMap ?? ['paso1_estimulo.mp3','paso2_receptor.mp3','paso3_procesamiento.mp3','paso4_efector.mp3','paso5_respuesta.mp3'];
}
