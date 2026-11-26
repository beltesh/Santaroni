import 'package:flutter_test/flutter_test.dart';
import 'package:santaroni/core/util/currency.dart';
import 'package:santaroni/core/util/slug.dart';

void main() {
  group('slugify', () {
    test('kebab-cases event names', () {
      expect(
        slugify('Comic Book Group Secret Santa 2026'),
        'comic-book-group-secret-santa-2026',
      );
    });

    test('strips accents and punctuation', () {
      expect(slugify('Año Nuevo: ¡Intercambio!'), 'ano-nuevo-intercambio');
      expect(slugify('  Navidad   en  Bogotá  '), 'navidad-en-bogota');
    });

    test('falls back when nothing is left', () {
      expect(slugify('🎁🎄'), 'secret-santa');
    });
  });

  group('budget', () {
    test('parses input into minor units', () {
      expect(parseBudget('25', 'USD'), 2500);
      expect(parseBudget('25.5', 'USD'), 2550);
      expect(parseBudget('25,50', 'EUR'), 2550);
      expect(parseBudget('\$1,000', 'USD'), 100000);
      expect(parseBudget('1.000', 'COP'), 1000); // COP has no decimals.
      expect(parseBudget('1.000', 'USD'), 100000);
      expect(parseBudget('5000', 'JPY'), 5000);
      expect(parseBudget('', 'USD'), isNull);
    });

    test('formats with the currency symbol', () {
      expect(formatBudget(2500, 'USD', locale: 'en_US'), '\$25');
      expect(formatBudget(1250, 'USD', locale: 'en_US'), '\$12.50');
      expect(formatBudget(5000, 'JPY', locale: 'en_US'), contains('5,000'));
      expect(formatBudget(2500, 'EUR', locale: 'es'), contains('€'));
    });
  });
}
