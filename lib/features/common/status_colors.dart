import 'package:material_ui/material_ui.dart';

/// Background/foreground pair for status cards and banners. Material's
/// scheme has no "warning" or "success" roles, so these are tuned by hand
/// for readable contrast in light and dark mode.
class StatusColors {
  const StatusColors(this.background, this.foreground);

  final Color background;
  final Color foreground;

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Amber: something needs the user's attention.
  static StatusColors warning(BuildContext context) => _dark(context)
      ? const StatusColors(Color(0xFF4A3000), Color(0xFFFFDDB3))
      : const StatusColors(Color(0xFFFFE6BF), Color(0xFF5A3A00));

  /// Green: all set.
  static StatusColors success(BuildContext context) => _dark(context)
      ? const StatusColors(Color(0xFF1E3A1F), Color(0xFFBFE8BC))
      : const StatusColors(Color(0xFFD5EFD2), Color(0xFF0F3D12));

  /// Solid green for the one action that's ready to go, meant to stand out
  /// from everything else on screen.
  static StatusColors go(BuildContext context) => _dark(context)
      ? const StatusColors(Color(0xFF7BD17F), Color(0xFF0A2E0C))
      : const StatusColors(Color(0xFF2E7D32), Colors.white);
}
