import '../errors/domain_exception.dart';

final class Money {
  Money(num amount, String currency)
      : amount = _validateAmount(amount),
        currency = _validateCurrency(currency);

  final double amount;
  final String currency;

  static double _validateAmount(num amount) {
    if (amount.isNaN || amount.isInfinite || amount < 0) {
      throw const DomainException(
        'INVALID_MONEY',
        'Money amount must be a non-negative finite number.',
      );
    }
    return double.parse(amount.toStringAsFixed(2));
  }

  static String _validateCurrency(String value) {
    final normalized = value.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(normalized)) {
      throw const DomainException(
        'INVALID_CURRENCY',
        'Currency must be a three-letter code.',
      );
    }
    return normalized;
  }

  Money add(Money other) {
    _assertSameCurrency(other);
    return Money(amount + other.amount, currency);
  }

  Money multiply(int multiplier) {
    if (multiplier < 0) {
      throw const DomainException(
        'INVALID_MULTIPLIER',
        'Multiplier must be non-negative.',
      );
    }
    return Money(amount * multiplier, currency);
  }

  void _assertSameCurrency(Money other) {
    if (other.currency != currency) {
      throw const DomainException(
        'CURRENCY_MISMATCH',
        'Money values must use the same currency.',
      );
    }
  }

  Map<String, Object> toJson() => {
        'amount': amount,
        'currency': currency,
      };
}
