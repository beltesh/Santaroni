/// What an email template is for. Each kind has its own variables (see
/// [TemplateVariable]) and its own built-in template.
enum TemplateKind {
  /// Tells each participant who they're giving to.
  assignment,

  /// Tells everyone the event was cancelled.
  cancellation,
}
