import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';

void main() {
  group('InstrumentEntity', () {
    const instrument1 = InstrumentEntity(
      instrumentId: 1,
      symbol: 'AAPL',
      sortIndex: 10,
      abreviation: 'AP',
    );

    const instrument2 = InstrumentEntity(
      instrumentId: 1,
      symbol: 'AAPL',
      sortIndex: 10,
      abreviation: 'AP',
    );

    const instrument3 = InstrumentEntity(
      instrumentId: 3,
      symbol: 'GOOG',
      sortIndex: 20,
      abreviation: 'GG',
    );

    test('should validate fields', () {
      expect(instrument3.symbol, equals('GOOG'));
      expect(instrument3.abreviation, equals('GG'));
      expect(instrument3.instrumentId, equals(3));
      expect(instrument3.sortIndex, equals(20));
    });

    test('supports value equality', () {
      expect(instrument1, equals(instrument2));
      expect(instrument1, isNot(equals(instrument3)));
    });

    test('props contains correct values', () {
      expect(
        instrument1.props,
        [1, 'AAPL', 10, 'AP'],
      );
    });
  });
}
