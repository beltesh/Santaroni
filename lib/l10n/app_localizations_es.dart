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
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeDark => 'Oscuro';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeDark => 'Tema oscuro';

  @override
  String get themeLight => 'Tema claro';

  @override
  String get themeFestiveDark => 'Navideño oscuro';

  @override
  String get themeFestiveLight => 'Navideño claro';

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
  String get removeAllParticipants => 'Quitar a todos';

  @override
  String get removeAllParticipantsTitle => '¿Quitar a todos los participantes?';

  @override
  String removeAllParticipantsBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se quitarán los $count participantes y sus listas de deseos.',
      one: 'Se quitará 1 participante y su lista de deseos.',
    );
    return '$_temp0';
  }

  @override
  String get removeAllCancelsDraw => 'También se cancelará el sorteo actual.';

  @override
  String get rosterChangeCancelsDraw =>
      'Si agregas o quitas personas, o cambias los grupos, se cancelará el sorteo actual.';

  @override
  String get ok => 'Aceptar';

  @override
  String get drawNames => 'Hacer el sorteo';

  @override
  String get drawReadyTitle => 'Listo para el sorteo';

  @override
  String get drawReadyBody =>
      'Todos quedarán conectados en un solo círculo: cada persona da un regalo y recibe uno. Todavía no se envía ningún correo.';

  @override
  String get drawDoneTitle => 'Sorteo hecho';

  @override
  String get drawDoneBody =>
      'Revisa el sorteo o guarda un respaldo. Todavía no se ha enviado ningún correo.';

  @override
  String get drawDoneSnack => '¡Sorteo hecho!';

  @override
  String get reviewDraw => 'Revisar';

  @override
  String get redraw => 'Volver a sortear';

  @override
  String get redrawTitle => '¿Volver a hacer el sorteo?';

  @override
  String get redrawBody =>
      'El sorteo actual se reemplazará por uno completamente nuevo.';

  @override
  String get drawErrorTitle => 'No se puede hacer el sorteo';

  @override
  String get drawErrorExclusions =>
      'Con estos grupos de exclusión no se puede hacer el sorteo. Un grupo puede tener como máximo la mitad de los participantes.';

  @override
  String get reviewTitle => 'Revisar sorteo';

  @override
  String get reviewHiddenHint =>
      'Los nombres están ocultos para que tú también puedas participar. Toca una fila o su ícono de ojo para verla.';

  @override
  String get drawVerified =>
      'Verificado: cada persona da y recibe exactamente un regalo, en un solo círculo.';

  @override
  String get drawInvalid =>
      'Este sorteo no pasó la verificación. Vuelve a sortear.';

  @override
  String get givesTo => 'le regala a';

  @override
  String get hiddenName => 'Nombre oculto';

  @override
  String get show => 'Mostrar';

  @override
  String get hide => 'Ocultar';

  @override
  String get showAll => 'Mostrar todo';

  @override
  String get hideAll => 'Ocultar todo';

  @override
  String get emailTemplates => 'Plantillas de correo';

  @override
  String get emailTemplatesSubtitle =>
      'Usa tu propio diseño de correo en texto o HTML';

  @override
  String get emailTemplate => 'Plantilla de correo';

  @override
  String get emailSubject => 'Asunto del correo';

  @override
  String emailSubjectTooltip(String tag) {
    return 'Usa $tag en cualquier parte del asunto para insertar el nombre del intercambio.';
  }

  @override
  String get emailSubjectRequired => 'Escribe un asunto';

  @override
  String get templatesIntro =>
      'Cada correo se arma a partir de una plantilla. Importa tu propio archivo .html o .txt con variables como las de la lista de abajo; Santaroni las llena para cada participante.';

  @override
  String get templatesBuiltIn => 'Incluidas';

  @override
  String get templatesImported => 'Importadas';

  @override
  String get templatesImportedEmpty => 'Aún no hay plantillas importadas.';

  @override
  String builtinTemplateName(String language) {
    return 'Predeterminada ($language)';
  }

  @override
  String get builtinTemplateSubtitle =>
      'Correo HTML, se usa salvo que el intercambio elija otra plantilla';

  @override
  String get builtinTemplateDescription =>
      'Un correo HTML festivo con todos los detalles del intercambio y la lista de deseos de la persona. Se envía junto con una versión en texto, para las apps de correo que no muestran HTML y para que no termine en spam. Guarda una copia para usarla como punto de partida de tu propio diseño.';

  @override
  String get saveTemplateCopy => 'Guardar una copia para personalizar';

  @override
  String get templateCopySaved =>
      'Plantilla guardada. Edítala y luego impórtala aquí.';

  @override
  String get importTemplate => 'Importar plantilla';

  @override
  String get formatHtml => 'HTML';

  @override
  String get formatText => 'Texto';

  @override
  String templateImportedOn(String date) {
    return 'importada el $date';
  }

  @override
  String templateImported(String name) {
    return 'Se importó “$name”';
  }

  @override
  String templateImportedWithProblem(String name) {
    return 'Se importó “$name”, pero hay que corregirla antes de poder usarla.';
  }

  @override
  String get templateReplaced => 'Plantilla actualizada';

  @override
  String get templateUnsupportedFile => 'Elige un archivo .html o .txt.';

  @override
  String get replaceFile => 'Reemplazar con otro archivo';

  @override
  String get templateNeedsFixing => 'hay que corregirla';

  @override
  String get templateNeedsFixingLong =>
      'Esta plantilla tiene un problema, así que no se pueden enviar correos hasta corregirla. Ve a Configuración › Plantillas de correo.';

  @override
  String get templateCannotSend =>
      'No se puede usar para enviar correos hasta corregirla';

  @override
  String templateUnknownVariable(String tag, int line) {
    return '$tag en la línea $line no es una variable que Santaroni conozca. Revisa cómo está escrita en la lista de variables.';
  }

  @override
  String templateSyntaxError(String message) {
    return 'No se pudo leer la plantilla: $message';
  }

  @override
  String templateSyntaxErrorAt(int line, String message) {
    return 'Línea $line: $message';
  }

  @override
  String get previewSample => 'Ejemplo';

  @override
  String get previewPlainVersion => 'Versión en texto';

  @override
  String get previewHtmlNote =>
      'Este es el texto que se envía junto con el HTML. Para ver el HTML, envíate un correo de prueba.';

  @override
  String get templateVariablesTitle => 'Variables que puedes usar';

  @override
  String get templateVariablesSubtitle =>
      'Escríbelas en tu archivo de plantilla';

  @override
  String get varEventName => 'Nombre del intercambio';

  @override
  String get varEventWhen => 'Fecha y hora juntas, las que estén definidas';

  @override
  String get varEventDate => 'Fecha';

  @override
  String get varEventTime => 'Hora';

  @override
  String get varEventPlace => 'Lugar';

  @override
  String get varBudget => 'Presupuesto, con símbolo de moneda';

  @override
  String get varGiverName => 'Nombre de la persona que recibe este correo';

  @override
  String get varGiverEmail => 'Su correo electrónico';

  @override
  String get varRecipientName => 'A quién le toca regalar';

  @override
  String get varOrganizerName => 'Tu nombre como remitente';

  @override
  String get varHasDetails =>
      'Sección que aparece si hay fecha, lugar o presupuesto';

  @override
  String get varHasWishlist =>
      'Sección que aparece si la persona tiene lista de deseos';

  @override
  String get varWishlist => 'Se repite por cada deseo, con Text y Url';

  @override
  String get deleteTemplateTitle => '¿Eliminar esta plantilla?';

  @override
  String get deleteTemplateBody =>
      'Los intercambios que la usan volverán a la plantilla predeterminada.';

  @override
  String get emailAccount => 'Cuenta de correo';

  @override
  String get emailAccountNotSetUp => 'Aún no está configurada';

  @override
  String get emailProvider => 'Proveedor de correo';

  @override
  String get providerGmail => 'Gmail';

  @override
  String get providerCustom => 'Otro (servidor SMTP)';

  @override
  String get gmailHelpTitle => 'Gmail necesita una contraseña de aplicación';

  @override
  String get gmailHelpStep1 =>
      '1. Activa la verificación en dos pasos de tu cuenta de Google.';

  @override
  String get gmailHelpStep2 =>
      '2. Crea una contraseña de aplicación (llámala “Santaroni”) en:';

  @override
  String get gmailHelpStep3 =>
      '3. Pega abajo el código de 16 letras. Tu contraseña normal de Gmail no funciona.';

  @override
  String get sentFolderWarningTitle => '¿Tú también participas?';

  @override
  String get sentFolderWarningBody =>
      'Gmail guarda una copia de cada correo en Enviados, así que ahí verías las asignaciones de todos. Usa una cuenta de Gmail gratuita aparte, solo para el intercambio.';

  @override
  String get senderName => 'Tu nombre';

  @override
  String get senderNameHelp =>
      'Aparece como remitente, y en las plantillas como el nombre de quien organiza';

  @override
  String get senderAddress => 'Correo electrónico';

  @override
  String get appPassword => 'Contraseña de aplicación';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordSavedHint => 'Guardada. Déjala vacía para conservarla.';

  @override
  String get passwordStorageNote =>
      'Se guarda de forma segura en el llavero de este dispositivo, nunca en la base de datos de la app ni en respaldos.';

  @override
  String get passwordRequired => 'Escribe la contraseña';

  @override
  String get serverSettings => 'Servidor';

  @override
  String get smtpHost => 'Servidor SMTP';

  @override
  String get smtpHostRequired => 'Escribe el nombre del servidor';

  @override
  String get smtpPort => 'Puerto';

  @override
  String get smtpPortInvalid => 'Puerto no válido';

  @override
  String get smtpSecurity => 'Seguridad';

  @override
  String get securityStartTls => 'STARTTLS (puerto 587)';

  @override
  String get securitySsl => 'SSL/TLS (puerto 465)';

  @override
  String get accountSaved => 'Cuenta de correo guardada';

  @override
  String get forgetAccount => 'Quitar cuenta';

  @override
  String get forgetAccountTitle => '¿Quitar esta cuenta de correo?';

  @override
  String get forgetAccountBody =>
      'Se borrarán su configuración y la contraseña guardada de este dispositivo. Tus intercambios no se ven afectados.';

  @override
  String get sendTestEmail => 'Enviarme un correo de prueba';

  @override
  String get sendingTestEmail => 'Enviando correo de prueba…';

  @override
  String get testEmailPrefix => '[Prueba] ';

  @override
  String get testEmailSentTitle => 'Correo de prueba enviado';

  @override
  String testEmailSentBody(String address) {
    return 'Revisa la bandeja de entrada de $address. Puede tardar un minuto en llegar.';
  }

  @override
  String get testEmailFailedTitle => 'No se pudo enviar el correo';

  @override
  String get accountNotReadyTitle => 'Se necesita una cuenta de correo';

  @override
  String get accountNotReadyBody =>
      'Primero configura la cuenta desde la que se enviarán los correos: tu dirección y su contraseña.';

  @override
  String get setUpAccount => 'Configurar cuenta';

  @override
  String get sendErrorAuthGmail =>
      'Gmail no aceptó la contraseña. Asegúrate de usar una contraseña de aplicación (no tu contraseña normal de Gmail) y de tener activada la verificación en dos pasos.';

  @override
  String get sendErrorAuth =>
      'El servidor no aceptó el correo o la contraseña.';

  @override
  String get sendErrorConnection =>
      'No se pudo conectar con el servidor de correo. Revisa tu conexión a internet y, si los escribiste, el nombre del servidor y el puerto.';

  @override
  String sendErrorRejected(String detail) {
    return 'El servidor rechazó el correo: $detail';
  }

  @override
  String sendErrorOther(String detail) {
    return 'Algo salió mal al enviar: $detail';
  }

  @override
  String get accountReadyTitle => 'Listo para enviar';

  @override
  String get accountSetUpTitle => 'Configura el correo';

  @override
  String get accountSetUpSubtitle => 'Se necesita para enviar las asignaciones';

  @override
  String get accountNeededBanner =>
      'Configura la cuenta de correo desde la que enviarás estas asignaciones.';

  @override
  String get templatesShortcutDefault => 'Con el diseño predeterminado';

  @override
  String templatesShortcutImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importadas',
      one: '1 importada',
    );
    return '$_temp0';
  }

  @override
  String get sendEmails => 'Enviar correos';

  @override
  String get emailStatus => 'Estado de los correos';

  @override
  String get sendPartlyTitle => 'Faltan correos por enviar';

  @override
  String get sendPartlyBody =>
      'Abre Estado de los correos para enviar los que faltan o reintentar los que fallaron.';

  @override
  String get allEmailsSent => 'Se enviaron todos los correos';

  @override
  String get sentBody =>
      'Todos tienen su asignación. Si a alguien se le perdió su correo, puedes reenviarlo desde Estado de los correos.';

  @override
  String get sendTitle => 'Enviar asignaciones';

  @override
  String get checkAccountReady => 'La cuenta de correo está lista';

  @override
  String get checkAccountMissing => 'La cuenta de correo no está configurada';

  @override
  String get checkTemplateReady => 'El asunto y la plantilla están listos';

  @override
  String get checkTemplateProblem =>
      'Hay que corregir el asunto o la plantilla';

  @override
  String get checkDrawReady => 'Sorteo hecho y verificado';

  @override
  String sentOfTotal(int sent, int total) {
    return '$sent de $total enviados';
  }

  @override
  String failedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count correos fallaron',
      one: '1 correo falló',
    );
    return '$_temp0';
  }

  @override
  String get sendingInProgress =>
      'Enviando… puedes salir de esta pantalla; el envío continúa.';

  @override
  String sendAllButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Enviar $count correos',
      one: 'Enviar 1 correo',
    );
    return '$_temp0';
  }

  @override
  String sendRemainingButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Enviar los $count que faltan',
      one: 'Enviar el correo que falta',
    );
    return '$_temp0';
  }

  @override
  String retryFailedButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reintentar los $count que fallaron',
      one: 'Reintentar el que falló',
    );
    return '$_temp0';
  }

  @override
  String get sendMePreview => 'Enviarme una vista previa';

  @override
  String get sendPrivacyNote =>
      'La vista previa usa los datos de este intercambio con nombres inventados, así que no revela ninguna asignación. Abajo solo se muestra quién recibe cada correo.';

  @override
  String sendConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Enviar $count correos?',
      one: '¿Enviar 1 correo?',
    );
    return '$_temp0';
  }

  @override
  String sendConfirmBody(String from) {
    return 'Cada participante recibirá su asignación desde $from. Una vez enviados los correos, ya no se pueden agregar ni quitar personas.';
  }

  @override
  String get sendNow => 'Enviar';

  @override
  String get stop => 'Detener';

  @override
  String get stopping => 'Deteniendo…';

  @override
  String get sendBlocked => 'Primero corrige lo que está marcado en la lista.';

  @override
  String sendFinished(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se enviaron $count correos',
      one: 'Se envió 1 correo',
    );
    return '$_temp0';
  }

  @override
  String sendFinishedWithFailures(int sent, int failed) {
    return '$sent enviados, $failed fallaron. Puedes reintentar los que fallaron.';
  }

  @override
  String sendStopped(int count) {
    return 'Se detuvo después de enviar $count. Los demás siguen pendientes.';
  }

  @override
  String get resend => 'Reenviar';

  @override
  String resendTitle(String name) {
    return '¿Reenviar a $name?';
  }

  @override
  String resendBody(String email) {
    return 'Recibirá su asignación otra vez en $email. Tú no verás a quién le tocó.';
  }

  @override
  String get statusSendingNow => 'Enviando…';

  @override
  String get statusEmailPending => 'Aún no se envía';

  @override
  String get statusEmailSent => 'Enviado';

  @override
  String statusEmailSentAt(String when) {
    return 'Enviado el $when';
  }

  @override
  String statusEmailFailed(String error) {
    return 'Falló: $error';
  }

  @override
  String get exportJson => 'Exportar JSON';

  @override
  String get exportTitle => 'Guardar un respaldo';

  @override
  String get exportBody =>
      'El respaldo completo incluye quién le regala a quién, en texto normal. Cualquiera que abra el archivo verá todas las asignaciones, incluida la tuya.';

  @override
  String get exportWithAssignments => 'Respaldo completo';

  @override
  String get exportWithoutAssignments => 'Sin asignaciones';

  @override
  String get exportSaved => 'Respaldo guardado';

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
  String get fileSaveError => 'No se pudo guardar el archivo.';

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
