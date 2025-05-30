import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';

void main() {
  group('QuoteEntity', () {
    const quote1 = QuoteEntity(
      instrumentId: 1,
      lastTradedPx: 100.5,
      rolling24HrVolume: 2000.0,
      rolling24HrPxChange: 5.5,
    );

    const quote2 = QuoteEntity(
      instrumentId: 1,
      lastTradedPx: 100.5,
      rolling24HrVolume: 2000.0,
      rolling24HrPxChange: 5.5,
    );

    const quote3 = QuoteEntity(
      instrumentId: 2,
      lastTradedPx: 101.0,
      rolling24HrVolume: 3000.0,
      rolling24HrPxChange: 6.0,
    );

    test('should validate fields', () {
      expect(quote3.instrumentId, equals(2));
      expect(quote3.lastTradedPx, equals(101.0));
      expect(quote3.rolling24HrVolume, equals(3000.0));
      expect(quote3.rolling24HrPxChange, equals(6.0));
    });

    test('supports value equality', () {
      expect(quote1, equals(quote2));
      expect(quote1, isNot(equals(quote3)));
    });

    test('props contains correct values', () {
      expect(
        quote1.props,
        [1, 100.5, 2000.0, 5.5],
      );
    });
  });
}
