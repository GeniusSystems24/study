import 'package:dart_layered_clean_architecture_example/src/domain/value_objects/money.dart';
import 'package:test/test.dart';

void main() {
  test('Money adds values with the same currency', () {
    final total = Money(10, 'USD').add(Money(5.5, 'USD'));
    expect(total.toJson(), {'amount': 15.5, 'currency': 'USD'});
  });

  test('Money rejects mismatched currencies', () {
    expect(
      () => Money(10, 'USD').add(Money(10, 'EUR')),
      throwsA(isA<Exception>()),
    );
  });
}
