// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Santaroni';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get remove => 'Remover';

  @override
  String get edit => 'Editar';

  @override
  String get clear => 'Limpar';

  @override
  String get optional => 'Opcional';

  @override
  String get homeEmptyTitle => 'Nenhum amigo secreto ainda';

  @override
  String get homeEmptyBody => 'Crie seu primeiro amigo secreto para começar.';

  @override
  String get newEvent => 'Novo amigo secreto';

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participantes',
      one: '1 participante',
      zero: 'Nenhum participante',
    );
    return '$_temp0';
  }

  @override
  String get statusDraft => 'Rascunho';

  @override
  String get statusGenerated => 'Sorteio feito';

  @override
  String get statusSending => 'Enviando';

  @override
  String get statusSent => 'Enviado';

  @override
  String get settings => 'Configurações';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeDark => 'Escuro';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeDark => 'Tema escuro';

  @override
  String get themeLight => 'Tema claro';

  @override
  String get themeFestiveDark => 'Natalino escuro';

  @override
  String get themeFestiveLight => 'Natalino claro';

  @override
  String get eventFormEditTitle => 'Editar amigo secreto';

  @override
  String get eventName => 'Nome do amigo secreto';

  @override
  String get eventNameHint => 'ex.: Amigo Secreto da Firma 2026';

  @override
  String get eventNameRequired => 'Digite um nome';

  @override
  String get eventDate => 'Data';

  @override
  String get eventTime => 'Horário';

  @override
  String get eventPlace => 'Local';

  @override
  String get eventBudget => 'Valor máximo';

  @override
  String get eventCurrency => 'Moeda';

  @override
  String get invalidAmount => 'Digite um valor válido';

  @override
  String get emailLanguage => 'Idioma dos e-mails';

  @override
  String budgetUpTo(String amount) {
    return 'Valor: até $amount';
  }

  @override
  String get eventDetailsEmpty => 'Ainda sem data, local ou valor.';

  @override
  String get deleteEventTitle => 'Excluir este amigo secreto?';

  @override
  String deleteEventBody(String name) {
    return '“$name” e todos os participantes serão excluídos permanentemente.';
  }

  @override
  String get eventLockedBanner =>
      'Os e-mails já foram enviados, então não dá mais para adicionar ou remover pessoas.';

  @override
  String get eventLockedError =>
      'Os e-mails deste amigo secreto já foram enviados.';

  @override
  String get participants => 'Participantes';

  @override
  String get addParticipant => 'Adicionar participante';

  @override
  String get importCsv => 'Importar CSV';

  @override
  String get participantsEmpty =>
      'Adicione as pessoas uma por uma ou importe um arquivo CSV.';

  @override
  String needMoreParticipants(int count) {
    return 'São necessários pelo menos $count participantes para o sorteio.';
  }

  @override
  String wishlistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count desejos',
      one: '1 desejo',
    );
    return '$_temp0';
  }

  @override
  String get participantFormEditTitle => 'Editar participante';

  @override
  String get participantName => 'Nome';

  @override
  String get participantEmail => 'E-mail';

  @override
  String get participantGroup => 'Grupo de exclusão';

  @override
  String get participantGroupHelp =>
      'Pessoas do mesmo grupo nunca tiram umas às outras, por exemplo casais ou quem mora junto.';

  @override
  String get nameRequired => 'Digite um nome';

  @override
  String get emailRequired => 'Digite um endereço de e-mail';

  @override
  String get emailInvalid => 'Isso não parece um endereço de e-mail';

  @override
  String get emailDuplicate => 'Alguém neste amigo secreto já usa este e-mail';

  @override
  String get wishlist => 'Lista de desejos';

  @override
  String get wishlistEmpty => 'Nenhum desejo ainda.';

  @override
  String get wishlistItem => 'Presente';

  @override
  String get wishlistLink => 'Link (opcional)';

  @override
  String get addWishlistItem => 'Adicionar presente';

  @override
  String deleteParticipantTitle(String name) {
    return 'Remover $name?';
  }

  @override
  String get deleteParticipantBody =>
      'A lista de desejos também será excluída.';

  @override
  String get removeAllParticipants => 'Remover todos';

  @override
  String get removeAllParticipantsTitle => 'Remover todos os participantes?';

  @override
  String removeAllParticipantsBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Todos os $count participantes e as listas de desejos serão removidos.',
      one: '1 participante e a lista de desejos serão removidos.',
    );
    return '$_temp0';
  }

  @override
  String get removeAllCancelsDraw => 'O sorteio atual também será cancelado.';

  @override
  String get rosterChangeCancelsDraw =>
      'Adicionar ou remover pessoas, ou mudar os grupos, cancela o sorteio atual.';

  @override
  String get ok => 'OK';

  @override
  String get drawNames => 'Fazer o sorteio';

  @override
  String get drawReadyTitle => 'Pronto para o sorteio';

  @override
  String get drawReadyBody =>
      'Todos ficam ligados em um único círculo: cada pessoa dá um presente e recebe um. Nenhum e-mail é enviado ainda.';

  @override
  String get drawDoneTitle => 'Sorteio feito';

  @override
  String get drawDoneBody =>
      'Confira o sorteio ou salve um backup. Nenhum e-mail foi enviado ainda.';

  @override
  String get drawDoneSnack => 'Sorteio feito!';

  @override
  String get reviewDraw => 'Conferir';

  @override
  String get redraw => 'Sortear de novo';

  @override
  String get redrawTitle => 'Fazer o sorteio de novo?';

  @override
  String get redrawBody =>
      'O sorteio atual será substituído por um completamente novo.';

  @override
  String get drawErrorTitle => 'Não dá para fazer o sorteio';

  @override
  String get drawErrorExclusions =>
      'Com esses grupos de exclusão o sorteio é impossível. Um grupo pode ter no máximo metade dos participantes.';

  @override
  String get reviewTitle => 'Conferir sorteio';

  @override
  String get reviewHiddenHint =>
      'Os nomes ficam escondidos para você também poder participar. Toque em uma linha ou no ícone de olho para revelar.';

  @override
  String get drawVerified =>
      'Verificado: cada pessoa dá e recebe exatamente um presente, em um único círculo.';

  @override
  String get drawInvalid =>
      'Este sorteio não passou na verificação. Sorteie de novo.';

  @override
  String get givesTo => 'tirou';

  @override
  String get hiddenName => 'Nome escondido';

  @override
  String get show => 'Mostrar';

  @override
  String get hide => 'Esconder';

  @override
  String get showAll => 'Mostrar todos';

  @override
  String get hideAll => 'Esconder todos';

  @override
  String get emailTemplates => 'Modelos de e-mail';

  @override
  String get emailTemplatesSubtitle =>
      'Use seu próprio design de e-mail em texto ou HTML';

  @override
  String get emailTemplate => 'Modelo de e-mail';

  @override
  String get emailSubject => 'Assunto do e-mail';

  @override
  String emailSubjectTooltip(String tag) {
    return 'Use $tag em qualquer parte do assunto para inserir o nome do amigo secreto.';
  }

  @override
  String get emailSubjectRequired => 'Digite um assunto';

  @override
  String get templatesIntro =>
      'Cada e-mail é montado a partir de um modelo. Importe seu próprio arquivo .html ou .txt com variáveis como as listadas abaixo; o Santaroni preenche tudo para cada participante.';

  @override
  String get templatesBuiltIn => 'Incluídos';

  @override
  String get templatesImported => 'Importados';

  @override
  String get templatesImportedEmpty => 'Nenhum modelo importado ainda.';

  @override
  String builtinTemplateName(String language) {
    return 'Padrão ($language)';
  }

  @override
  String get builtinTemplateSubtitle =>
      'E-mail em HTML, usado a menos que o amigo secreto escolha outro modelo';

  @override
  String get builtinTemplateDescription =>
      'Um e-mail festivo em HTML com todos os detalhes do amigo secreto e a lista de desejos de quem foi tirado. Uma versão em texto vai junto, para apps de e-mail que não mostram HTML e para ajudar a não cair no spam. Salve uma cópia para usar como ponto de partida do seu próprio design.';

  @override
  String get saveTemplateCopy => 'Salvar uma cópia para personalizar';

  @override
  String get templateCopySaved => 'Modelo salvo. Edite e depois importe aqui.';

  @override
  String get importTemplate => 'Importar modelo';

  @override
  String get formatHtml => 'HTML';

  @override
  String get formatText => 'Texto';

  @override
  String templateImportedOn(String date) {
    return 'importado em $date';
  }

  @override
  String templateImported(String name) {
    return '“$name” importado';
  }

  @override
  String templateImportedWithProblem(String name) {
    return '“$name” foi importado, mas precisa de correção antes de ser usado.';
  }

  @override
  String get templateReplaced => 'Modelo atualizado';

  @override
  String get templateUnsupportedFile => 'Escolha um arquivo .html ou .txt.';

  @override
  String get replaceFile => 'Substituir por outro arquivo';

  @override
  String get templateNeedsFixing => 'precisa de correção';

  @override
  String get templateNeedsFixingLong =>
      'Este modelo tem um problema, então os e-mails não podem ser enviados até ele ser corrigido. Veja em Configurações › Modelos de e-mail.';

  @override
  String get templateCannotSend =>
      'Não pode ser usado para enviar e-mails até ser corrigido';

  @override
  String templateUnknownVariable(String tag, int line) {
    return '$tag na linha $line não é uma variável que o Santaroni conhece. Confira a escrita na lista de variáveis.';
  }

  @override
  String templateSyntaxError(String message) {
    return 'Não foi possível ler o modelo: $message';
  }

  @override
  String templateSyntaxErrorAt(int line, String message) {
    return 'Linha $line: $message';
  }

  @override
  String get previewSample => 'Exemplo';

  @override
  String get previewPlainVersion => 'Versão em texto';

  @override
  String get previewHtmlNote =>
      'Este é o texto enviado junto com o HTML. Para ver o HTML, envie um e-mail de teste para você.';

  @override
  String get templateVariablesTitle => 'Variáveis que você pode usar';

  @override
  String get templateVariablesSubtitle => 'Escreva-as no seu arquivo de modelo';

  @override
  String get varEventName => 'Nome do amigo secreto';

  @override
  String get varEventWhen =>
      'Data e horário juntos, os que estiverem definidos';

  @override
  String get varEventDate => 'Data';

  @override
  String get varEventTime => 'Horário';

  @override
  String get varEventPlace => 'Local';

  @override
  String get varBudget => 'Valor, com o símbolo da moeda';

  @override
  String get varGiverName => 'Nome de quem recebe este e-mail';

  @override
  String get varGiverEmail => 'O e-mail dessa pessoa';

  @override
  String get varRecipientName => 'Quem ela tirou';

  @override
  String get varOrganizerName => 'Seu nome como remetente';

  @override
  String get varHasDetails =>
      'Seção que aparece quando há data, local ou valor';

  @override
  String get varHasWishlist =>
      'Seção que aparece quando quem foi tirado tem lista de desejos';

  @override
  String get varWishlist => 'Repete para cada desejo, com Text e Url';

  @override
  String get deleteTemplateTitle => 'Excluir este modelo?';

  @override
  String get deleteTemplateBody =>
      'Os amigos secretos que usam este modelo voltarão para o modelo padrão.';

  @override
  String get emailAccount => 'Conta de e-mail';

  @override
  String get emailAccountNotSetUp => 'Ainda não configurada';

  @override
  String get emailProvider => 'Provedor de e-mail';

  @override
  String get providerGmail => 'Gmail';

  @override
  String get providerCustom => 'Outro (servidor SMTP)';

  @override
  String get gmailHelpTitle => 'O Gmail precisa de uma senha de app';

  @override
  String get gmailHelpStep1 =>
      '1. Ative a verificação em duas etapas da sua Conta do Google.';

  @override
  String get gmailHelpStep2 =>
      '2. Crie uma senha de app (chame de “Santaroni”) em:';

  @override
  String get gmailHelpStep3 =>
      '3. Cole abaixo o código de 16 letras. Sua senha normal do Gmail não funciona.';

  @override
  String get sentFolderWarningTitle => 'Você também vai participar?';

  @override
  String get sentFolderWarningBody =>
      'O Gmail guarda uma cópia de cada e-mail em Enviados, então você veria todos os sorteados lá. Use uma conta do Gmail gratuita separada só para o amigo secreto.';

  @override
  String get senderName => 'Seu nome';

  @override
  String get senderNameHelp =>
      'Aparece como remetente e, nos modelos, como o nome de quem organiza';

  @override
  String get senderAddress => 'Endereço de e-mail';

  @override
  String get appPassword => 'Senha de app';

  @override
  String get password => 'Senha';

  @override
  String get passwordSavedHint => 'Salva. Deixe em branco para manter.';

  @override
  String get passwordStorageNote =>
      'Guardada com segurança no chaveiro deste dispositivo, nunca no banco de dados do app nem em backups.';

  @override
  String get passwordRequired => 'Digite a senha';

  @override
  String get serverSettings => 'Servidor';

  @override
  String get smtpHost => 'Servidor SMTP';

  @override
  String get smtpHostRequired => 'Digite o nome do servidor';

  @override
  String get smtpPort => 'Porta';

  @override
  String get smtpPortInvalid => 'Porta inválida';

  @override
  String get smtpSecurity => 'Segurança';

  @override
  String get securityStartTls => 'STARTTLS (porta 587)';

  @override
  String get securitySsl => 'SSL/TLS (porta 465)';

  @override
  String get accountSaved => 'Conta de e-mail salva';

  @override
  String get forgetAccount => 'Remover conta';

  @override
  String get forgetAccountTitle => 'Remover esta conta de e-mail?';

  @override
  String get forgetAccountBody =>
      'As configurações e a senha salva serão apagadas deste dispositivo. Seus amigos secretos não são afetados.';

  @override
  String get sendTestEmail => 'Me enviar um e-mail de teste';

  @override
  String get sendingTestEmail => 'Enviando e-mail de teste…';

  @override
  String get testEmailPrefix => '[Teste] ';

  @override
  String get testEmailSentTitle => 'E-mail de teste enviado';

  @override
  String testEmailSentBody(String address) {
    return 'Confira a caixa de entrada de $address. Pode levar um minuto para chegar.';
  }

  @override
  String get testEmailFailedTitle => 'Não foi possível enviar o e-mail';

  @override
  String get accountNotReadyTitle => 'É preciso uma conta de e-mail';

  @override
  String get accountNotReadyBody =>
      'Primeiro configure a conta de onde os e-mails serão enviados: seu endereço de e-mail e a senha.';

  @override
  String get setUpAccount => 'Configurar conta';

  @override
  String get sendErrorAuthGmail =>
      'O Gmail não aceitou a senha. Confira se é uma senha de app (não sua senha normal do Gmail) e se a verificação em duas etapas está ativada.';

  @override
  String get sendErrorAuth =>
      'O servidor não aceitou o endereço de e-mail ou a senha.';

  @override
  String get sendErrorConnection =>
      'Não foi possível conectar ao servidor de e-mail. Confira sua conexão com a internet e, se você digitou, o nome do servidor e a porta.';

  @override
  String sendErrorRejected(String detail) {
    return 'O servidor recusou o e-mail: $detail';
  }

  @override
  String sendErrorOther(String detail) {
    return 'Algo deu errado no envio: $detail';
  }

  @override
  String get accountReadyTitle => 'Pronto para enviar';

  @override
  String get accountSetUpTitle => 'Configure o e-mail';

  @override
  String get accountSetUpSubtitle => 'Necessário para enviar os sorteados';

  @override
  String get accountNeededBanner =>
      'Configure a conta de e-mail de onde você vai enviar estes sorteados.';

  @override
  String get templatesShortcutDefault => 'Usando o design padrão';

  @override
  String templatesShortcutImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importados',
      one: '1 importado',
    );
    return '$_temp0';
  }

  @override
  String get sendEmails => 'Enviar e-mails';

  @override
  String get emailStatus => 'Status dos e-mails';

  @override
  String get sendPartlyTitle => 'Alguns e-mails não foram enviados';

  @override
  String get sendPartlyBody =>
      'Abra Status dos e-mails para enviar o restante ou tentar de novo os que falharam.';

  @override
  String get allEmailsSent => 'Todos os e-mails enviados';

  @override
  String get sentBody =>
      'Todo mundo já sabe quem tirou. Se alguém perdeu o e-mail, você pode reenviar em Status dos e-mails.';

  @override
  String get sendTitle => 'Enviar sorteados';

  @override
  String get checkAccountReady => 'A conta de e-mail está pronta';

  @override
  String get checkAccountMissing => 'A conta de e-mail não está configurada';

  @override
  String get checkTemplateReady => 'Assunto e modelo prontos';

  @override
  String get checkTemplateProblem =>
      'O assunto ou o modelo precisa de correção';

  @override
  String get checkDrawReady => 'Sorteio feito e verificado';

  @override
  String sentOfTotal(int sent, int total) {
    return '$sent de $total enviados';
  }

  @override
  String failedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count e-mails falharam',
      one: '1 e-mail falhou',
    );
    return '$_temp0';
  }

  @override
  String get sendingInProgress =>
      'Enviando… você pode sair desta tela; o envio continua.';

  @override
  String sendAllButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Enviar $count e-mails',
      one: 'Enviar 1 e-mail',
    );
    return '$_temp0';
  }

  @override
  String sendRemainingButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Enviar os $count que faltam',
      one: 'Enviar o e-mail que falta',
    );
    return '$_temp0';
  }

  @override
  String retryFailedButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tentar de novo os $count que falharam',
      one: 'Tentar de novo o que falhou',
    );
    return '$_temp0';
  }

  @override
  String get sendMePreview => 'Me enviar uma prévia';

  @override
  String get sendPrivacyNote =>
      'A prévia usa os detalhes deste amigo secreto com nomes inventados, então não revela quem tirou quem. Abaixo só aparece quem recebe cada e-mail.';

  @override
  String sendConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Enviar $count e-mails?',
      one: 'Enviar 1 e-mail?',
    );
    return '$_temp0';
  }

  @override
  String sendConfirmBody(String from) {
    return 'Cada participante recebe quem tirou a partir de $from. Depois que os e-mails saírem, não dá mais para adicionar ou remover pessoas.';
  }

  @override
  String get sendNow => 'Enviar';

  @override
  String get stop => 'Parar';

  @override
  String get stopping => 'Parando…';

  @override
  String get sendBlocked => 'Primeiro corrija os itens marcados na lista.';

  @override
  String sendFinished(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count e-mails enviados',
      one: '1 e-mail enviado',
    );
    return '$_temp0';
  }

  @override
  String sendFinishedWithFailures(int sent, int failed) {
    return '$sent enviados, $failed falharam. Você pode tentar de novo os que falharam.';
  }

  @override
  String sendStopped(int count) {
    return 'Parou depois de enviar $count. O restante está aguardando.';
  }

  @override
  String get resend => 'Reenviar';

  @override
  String resendTitle(String name) {
    return 'Reenviar para $name?';
  }

  @override
  String resendBody(String email) {
    return 'A pessoa vai receber de novo quem tirou, em $email. Você não vai ver quem é.';
  }

  @override
  String get statusSendingNow => 'Enviando…';

  @override
  String get statusEmailPending => 'Ainda não enviado';

  @override
  String get statusEmailSent => 'Enviado';

  @override
  String statusEmailSentAt(String when) {
    return 'Enviado em $when';
  }

  @override
  String statusEmailFailed(String error) {
    return 'Falhou: $error';
  }

  @override
  String get exportJson => 'Exportar JSON';

  @override
  String get exportTitle => 'Salvar um backup';

  @override
  String get exportBody =>
      'O backup completo inclui quem tirou quem, em texto comum. Qualquer pessoa que abrir o arquivo vai ver todos os sorteados, inclusive o seu.';

  @override
  String get exportWithAssignments => 'Backup completo';

  @override
  String get exportWithoutAssignments => 'Sem os sorteados';

  @override
  String get exportSaved => 'Backup salvo';

  @override
  String get csvImportTitle => 'Importar participantes';

  @override
  String get csvIntro =>
      'Escolha um arquivo CSV com um participante por linha. A primeira linha precisa ter os nomes das colunas. Dá para exportar do Excel, do Planilhas Google ou do Formulários Google.';

  @override
  String get csvColumnsRequired => 'Colunas obrigatórias: nome, e-mail';

  @override
  String get csvColumnsOptional => 'Colunas opcionais: desejos, grupo';

  @override
  String get csvWishlistTip =>
      'Coloque cada desejo em uma linha própria dentro da célula (Alt+Enter na maioria das planilhas), ou separe com \" | \". Links no fim de cada desejo são detectados automaticamente.';

  @override
  String get csvChooseFile => 'Escolher arquivo CSV';

  @override
  String get csvChooseAnother => 'Escolher outro';

  @override
  String get csvSaveExample => 'Salvar arquivo de exemplo';

  @override
  String get csvExampleSaved => 'Arquivo de exemplo salvo';

  @override
  String get fileSaveError => 'Não foi possível salvar o arquivo.';

  @override
  String get csvReadError => 'Não foi possível ler esse arquivo.';

  @override
  String get csvColName => 'nome';

  @override
  String get csvColEmail => 'e-mail';

  @override
  String get csvColWishlist => 'desejos';

  @override
  String get csvColGroup => 'grupo';

  @override
  String csvMissingColumns(String columns) {
    return 'Faltam colunas obrigatórias neste arquivo: $columns';
  }

  @override
  String get csvNothingToImport =>
      'Nenhum participante encontrado neste arquivo.';

  @override
  String csvReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participantes prontos para importar',
      one: '1 participante pronto para importar',
    );
    return '$_temp0';
  }

  @override
  String csvSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas ignoradas',
      one: '1 linha ignorada',
    );
    return '$_temp0';
  }

  @override
  String csvRowError(int row, String problem) {
    return 'Linha $row: $problem';
  }

  @override
  String get csvProblemMissingName => 'falta o nome';

  @override
  String get csvProblemMissingEmail => 'falta o e-mail';

  @override
  String csvProblemInvalidEmail(String value) {
    return 'e-mail inválido “$value”';
  }

  @override
  String csvProblemDuplicateEmail(String value) {
    return '“$value” já está neste amigo secreto';
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
      other: '$count participantes importados',
      one: '1 participante importado',
    );
    return '$_temp0';
  }
}
