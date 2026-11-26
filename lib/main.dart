import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Emails are formatted in each event's language, which can differ from
  // the app's, so load date formats for every locale up front.
  await initializeDateFormatting();
  runApp(const ProviderScope(child: SantaroniApp()));
}
