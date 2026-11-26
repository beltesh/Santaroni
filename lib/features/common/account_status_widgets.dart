import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../l10n/app_localizations.dart';
import '../settings/email_account_screen.dart';
import '../templates/templates_screen.dart';
import 'status_colors.dart';

void openEmailAccount(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const EmailAccountScreen()));

/// Two small shortcut cards for the top of the home screen: the email
/// account (amber until set up, then green) and the email templates.
class HomeShortcuts extends ConsumerWidget {
  const HomeShortcuts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(accountStatusProvider).value;
    final imported = ref.watch(templatesProvider).value?.length ?? 0;
    final scheme = Theme.of(context).colorScheme;

    final Widget account;
    if (status == null) {
      account = _ShortcutCard(
        icon: Icons.mail_lock_outlined,
        title: l10n.emailAccount,
        subtitle: '',
        colors: StatusColors(scheme.surfaceContainerHigh, scheme.onSurface),
        onTap: () => openEmailAccount(context),
      );
    } else if (status.isReady) {
      account = _ShortcutCard(
        icon: Icons.check_circle,
        title: l10n.accountReadyTitle,
        subtitle: status.account!.address,
        colors: StatusColors.success(context),
        onTap: () => openEmailAccount(context),
      );
    } else {
      account = _ShortcutCard(
        icon: Icons.warning_amber_rounded,
        title: l10n.accountSetUpTitle,
        subtitle: l10n.accountSetUpSubtitle,
        colors: StatusColors.warning(context),
        onTap: () => openEmailAccount(context),
      );
    }

    final templates = _ShortcutCard(
      icon: Icons.mail_outline,
      title: l10n.emailTemplates,
      subtitle: imported == 0
          ? l10n.templatesShortcutDefault
          : l10n.templatesShortcutImported(imported),
      colors: StatusColors(scheme.surfaceContainerHigh, scheme.onSurface),
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const TemplatesScreen())),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: account),
          const SizedBox(width: 8),
          Expanded(child: templates),
        ],
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final StatusColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      color: colors.background,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: colors.foreground),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall?.copyWith(
                        color: colors.foreground,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: colors.foreground,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Amber banner on the event screen while no sending account is ready.
class AccountNeededBanner extends ConsumerWidget {
  const AccountNeededBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(accountStatusProvider).value;
    if (status == null || status.isReady) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colors = StatusColors.warning(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        margin: EdgeInsets.zero,
        color: colors.background,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: colors.foreground),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.accountNeededBanner,
                  style: TextStyle(color: colors.foreground),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: colors.foreground),
                onPressed: () => openEmailAccount(context),
                child: Text(l10n.setUpAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
