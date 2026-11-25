import 'package:intl/intl.dart';

/// ISO 4217 codes offered in the currency picker. Any valid code works for
/// formatting; this list just keeps the picker short.
const commonCurrencies = <String>[
  'USD', 'EUR', 'GBP', 'CAD', 'MXN', 'AUD', 'NZD', 'JPY', 'CNY', 'INR', //
  'BRL', 'ARS', 'CLP', 'COP', 'PEN', 'UYU', 'BOB', 'PYG', 'VES', 'CRC', //
  'GTQ', 'HNL', 'NIO', 'PAB', 'DOP', 'CHF', 'SEK', 'NOK', 'DKK', 'PLN', //
  'CZK', 'KRW', 'PHP', 'ZAR', 'TRY', 'ILS',
];

const defaultCurrency = 'USD';

/// Number of decimal places the currency uses (2 for USD, 0 for JPY/CLP).
int currencyDecimalDigits(String currencyCode) =>
    NumberFormat.simpleCurrency(name: currencyCode).decimalDigits ?? 2;

/// Converts a stored amount in minor units (cents) to a display string such
/// as "$25", "25 €" or "$12.50", following [locale]'s conventions.
/// Whole amounts are shown without decimals.
String formatBudget(int minorUnits, String currencyCode, {String? locale}) {
  final digits = currencyDecimalDigits(currencyCode);
  final scale = _pow10(digits);
  final whole = minorUnits % scale == 0;
  final format = NumberFormat.simpleCurrency(
    locale: locale,
    name: currencyCode,
    decimalDigits: whole ? 0 : digits,
  );
  return format.format(minorUnits / scale);
}

/// Parses user input such as "25", "25.5" or "25,50" into minor units.
/// Returns null for empty or invalid input.
int? parseBudget(String input, String currencyCode) {
  final cleaned = input.trim().replaceAll(RegExp(r'[^0-9.,]'), '');
  if (cleaned.isEmpty) return null;
  // Treat the last '.' or ',' as the decimal separator if it is followed by
  // one or two digits; any other separators are thousands separators.
  final match = RegExp(r'^(.*?)[.,](\d{1,2})$').firstMatch(cleaned);
  final wholePart = (match?.group(1) ?? cleaned).replaceAll(RegExp(r'[.,]'), '');
  final fraction = match?.group(2) ?? '';
  final digits = currencyDecimalDigits(currencyCode);
  final whole = int.tryParse(wholePart.isEmpty ? '0' : wholePart);
  if (whole == null) return null;
  final scale = _pow10(digits);
  final fractionMinor = digits == 0
      ? 0
      : int.parse(fraction.padRight(digits, '0').substring(0, digits));
  return whole * scale + fractionMinor;
}

int _pow10(int exponent) {
  var result = 1;
  for (var i = 0; i < exponent; i++) {
    result *= 10;
  }
  return result;
}
