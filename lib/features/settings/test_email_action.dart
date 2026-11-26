import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/email/email_providers.dart';
import '../../core/email/email_renderer.dart';
import '../../core/email/mail_transport.dart';
import '../../data/database.dart';
import '../../data/email_service.dart';
import '../../l10n/app_localizations.dart';
import 'email_account_screen.dart';

/// Explains a sending failure in plain words.
String describeSendFailure(
  AppLocalizations l10n,
  SendException e,
  EmailProvider provider,
) => switch (e.failure) {
  SendFailure.authentication =>
    provider == EmailProvider.gmail
        ? l10n.sendErrorAuthGmail
        : l10n.sendErrorAuth,
  SendFailure.connection => l10n.sendErrorConnection,
  SendFailure.rejected => l10n.sendErrorRejected(e.detail),
  SendFailure.other => l10n.sendErrorOther(e.detail),
};

/// Sends a sample email to the organizer, showing progress and the outcome
/// in a dialog.
Future<void> sendTestEmail(
  BuildContext context,
  WidgetRef ref, {
  required String subject,
  required BodyTemplate body,
  required String languageCode,
  Event? event,
}) async {
  final l10n = AppLocalizations.of(context);
  final account = await ref.read(emailAccountRepositoryProvider).load();
  final provider = account?.provider ?? EmailProvider.gmail;
  if (!context.mounted) return;

  final future = ref
      .read(emailServiceProvider)
      .sendTest(
        subject: subject,
        body: body,
        languageCode: languageCode,
        event: event,
        testPrefix: l10n.testEmailPrefix,
      );

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => FutureBuilder<String>(
      future: future,
      builder: (dialogContext, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return AlertDialog(
            content: Row(
              children: [
                const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(l10n.sendingTestEmail)),
              ],
            ),
          );
        }

        final error = snapshot.error;
        final notReady = error is AccountNotReadyException;
        final (icon, title, message) = switch (error) {
          null => (
            Icons.mark_email_read_outlined,
            l10n.testEmailSentTitle,
            l10n.testEmailSentBody(snapshot.data!),
          ),
          AccountNotReadyException() => (
            Icons.manage_accounts_outlined,
            l10n.accountNotReadyTitle,
            l10n.accountNotReadyBody,
          ),
          SendException() => (
            Icons.error_outline,
            l10n.testEmailFailedTitle,
            describeSendFailure(l10n, error, provider),
          ),
          _ => (
            Icons.error_outline,
            l10n.testEmailFailedTitle,
            l10n.sendErrorOther('$error'),
          ),
        };

        return AlertDialog(
          icon: Icon(icon),
          title: Text(title),
          content: Text(message),
          actions: [
            if (notReady)
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const EmailAccountScreen(),
                    ),
                  );
                },
                child: Text(l10n.setUpAccount),
              ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    ),
  );
}
