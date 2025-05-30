import 'package:currency_formatter/currency_formatter.dart';

CurrencyFormat _brCurrency = const CurrencyFormat(
  symbol: 'R\$',
  thousandSeparator: '.',
  decimalSeparator: ',',
);

extension NumberExtension on double {
  String formatToCurrency() {
    return CurrencyFormatter.format(this, _brCurrency);
  }
}
