// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Santaroni';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get remove => 'Quitar';

  @override
  String get edit => 'Editar';

  @override
  String get clear => 'Borrar';

  @override
  String get optional => 'Opcional';

  @override
  String get homeEmptyTitle => 'Aún no hay intercambios';

  @override
  String get homeEmptyBody => 'Crea tu primer intercambio para empezar.';

  @override
  String get newEvent => 'Nuevo intercambio';

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participantes',
      one: '1 participante',
      zero: 'Sin participantes',
    );
    return '$_temp0';
  }

  @override
  String get statusDraft => 'Borrador';

  @override
  String get statusGenerated => 'Sorteo hecho';

  @override
  String get statusSending => 'Enviando';

  @override
  String get statusSent => 'Enviado';

  @override
  String get settings => 'Configuración';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get eventFormEditTitle => 'Editar intercambio';

  @override
  String get eventName => 'Nombre del intercambio';

  @override
  String get eventNameHint => 'p. ej. Intercambio navideño de la oficina 2026';

  @override
  String get eventNameRequired => 'Escribe un nombre';

  @override
  String get eventDate => 'Fecha';

  @override
  String get eventTime => 'Hora';

  @override
  String get eventPlace => 'Lugar';

  @override
  String get eventBudget => 'Presupuesto máximo';

  @override
  String get eventCurrency => 'Moneda';

  @override
  String get invalidAmount => 'Escribe una cantidad válida';

  @override
  String get emailLanguage => 'Idioma de los correos';

  @override
  String budgetUpTo(String amount) {
    return 'Presupuesto: hasta $amount';
  }

  @override
  String get eventDetailsEmpty => 'Aún no hay fecha, lugar ni presupuesto.';

  @override
  String get deleteEventTitle => '¿Eliminar este intercambio?';

  @override
  String deleteEventBody(String name) {
    return 'Se eliminarán “$name” y todos sus participantes de forma permanente.';
  }

  @override
  String get eventLockedBanner =>
      'Ya se enviaron los correos, así que no se pueden agregar ni quitar personas.';

  @override
  String get eventLockedError =>
      'Ya se enviaron los correos de este intercambio.';

  @override
  String get participants => 'Participantes';

  @override
  String get addParticipant => 'Agregar participante';

  @override
  String get importCsv => 'Importar CSV';

  @override
  String get participantsEmpty =>
      'Agrega personas una por una o importa un archivo CSV.';

  @override
  String needMoreParticipants(int count) {
    return 'Se necesitan al menos $count participantes para hacer el sorteo.';
  }

  @override
  String wishlistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deseos',
      one: '1 deseo',
    );
    return '$_temp0';
  }

  @override
  String get participantFormEditTitle => 'Editar participante';

  @override
  String get participantName => 'Nombre';

  @override
  String get participantEmail => 'Correo electrónico';

  @override
  String get participantGroup => 'Grupo de exclusión';

  @override
  String get participantGroupHelp =>
      'A las personas del mismo grupo nunca les tocará regalarse entre sí, p. ej. parejas o roomies.';

  @override
  String get nameRequired => 'Escribe un nombre';

  @override
  String get emailRequired => 'Escribe un correo electrónico';

  @override
  String get emailInvalid => 'Ese correo no parece válido';

  @override
  String get emailDuplicate => 'Alguien en este intercambio ya usa este correo';

  @override
  String get wishlist => 'Lista de deseos';

  @override
  String get wishlistEmpty => 'Aún no hay deseos.';

  @override
  String get wishlistItem => 'Regalo';

  @override
  String get wishlistLink => 'Enlace (opcional)';

  @override
  String get addWishlistItem => 'Agregar regalo';

  @override
  String deleteParticipantTitle(String name) {
    return '¿Quitar a $name?';
  }

  @override
  String get deleteParticipantBody => 'También se borrará su lista de deseos.';

  @override
  String get csvImportTitle => 'Importar participantes';

  @override
  String get csvIntro =>
      'Elige un archivo CSV con un participante por fila. La primera fila debe tener los nombres de las columnas. Puedes exportarlo desde Excel, Hojas de cálculo de Google o Formularios de Google.';

  @override
  String get csvColumnsRequired => 'Columnas obligatorias: nombre, correo';

  @override
  String get csvColumnsOptional => 'Columnas opcionales: deseos, grupo';

  @override
  String get csvWishlistTip =>
      'Pon cada deseo en su propia línea dentro de la celda (Alt+Enter en la mayoría de las hojas de cálculo), o sepáralos con \" | \". Los enlaces al final de cada deseo se detectan automáticamente.';

  @override
  String get csvChooseFile => 'Elegir archivo CSV';

  @override
  String get csvChooseAnother => 'Elegir otro';

  @override
  String get csvSaveExample => 'Guardar archivo de ejemplo';

  @override
  String get csvExampleSaved => 'Se guardó el archivo de ejemplo';

  @override
  String get csvSaveError => 'No se pudo guardar el archivo.';

  @override
  String get csvReadError => 'No se pudo leer el archivo.';

  @override
  String get csvColName => 'nombre';

  @override
  String get csvColEmail => 'correo';

  @override
  String get csvColWishlist => 'deseos';

  @override
  String get csvColGroup => 'grupo';

  @override
  String csvMissingColumns(String columns) {
    return 'A este archivo le faltan columnas obligatorias: $columns';
  }

  @override
  String get csvNothingToImport =>
      'No se encontraron participantes en este archivo.';

  @override
  String csvReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participantes listos para importar',
      one: '1 participante listo para importar',
    );
    return '$_temp0';
  }

  @override
  String csvSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se omitieron $count filas',
      one: 'Se omitió 1 fila',
    );
    return '$_temp0';
  }

  @override
  String csvRowError(int row, String problem) {
    return 'Fila $row: $problem';
  }

  @override
  String get csvProblemMissingName => 'falta el nombre';

  @override
  String get csvProblemMissingEmail => 'falta el correo';

  @override
  String csvProblemInvalidEmail(String value) {
    return 'correo no válido “$value”';
  }

  @override
  String csvProblemDuplicateEmail(String value) {
    return '“$value” ya está en este intercambio';
  }

  @override
  String csvImportButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importar $count participantes',
      one: 'Importar 1 participante',
    );
    return '$_temp0';
  }

  @override
  String csvImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se importaron $count participantes',
      one: 'Se importó 1 participante',
    );
    return '$_temp0';
  }
}
