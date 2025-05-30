import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/features/home/data/models/instrument_model.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';

void main() {
  const instrumentModel = InstrumentModel(
    instrumentId: 1,
    symbol: 'BTCUSD',
    sortIndex: 10,
    abreviation: 'BTC',
  );

  final instrumentJson = {
    'InstrumentId': 1,
    'Symbol': 'BTCUSD',
    'SortIndex': 10,
    'Product1Symbol': 'BTC',
  };

  group('Instrument Model class', () {
    test('fromJson should return a valid model', () {
      final result = InstrumentModel.fromJson(instrumentJson);
      expect(result, instrumentModel);
    });

    test(
        'fromJson should set abreviation to empty string if Product1Symbol is null',
        () {
      final json = {
        'InstrumentId': 2,
        'Symbol': 'ETHUSD',
        'SortIndex': 20,
        'Product1Symbol': null,
      };
      final result = InstrumentModel.fromJson(json);
      expect(result.abreviation, '');
    });

    test('toEntity should return a valid InstrumentEntity', () {
      final entity = instrumentModel.toEntity();
      expect(entity, isA<InstrumentEntity>());
      expect(entity.instrumentId, instrumentModel.instrumentId);
      expect(entity.symbol, instrumentModel.symbol);
      expect(entity.sortIndex, instrumentModel.sortIndex);
      expect(entity.abreviation, instrumentModel.abreviation);
    });

    test('props should contain all properties', () {
      expect(
        instrumentModel.props,
        [1, 'BTCUSD', 10, 'BTC'],
      );
    });
  });
}
