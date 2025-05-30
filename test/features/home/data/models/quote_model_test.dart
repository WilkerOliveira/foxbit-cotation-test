import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/features/home/data/models/quote_model.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';

void main() {
  const quoteModel = QuoteModel(
    instrumentId: 1,
    lastTradedPx: 100.5,
    rolling24HrVolume: 2000.0,
    rolling24HrPxChange: -2.5,
  );

  final quoteJson = {
    'InstrumentId': 1,
    'LastTradedPx': 100.5,
    'Rolling24HrVolume': 2000.0,
    'Rolling24HrPxChange': -2.5,
  };

  group('Quote Model class', () {
    test('fromJson should return a valid model', () {
      final result = QuoteModel.fromJson(quoteJson);
      expect(result, quoteModel);
    });

    test('fromJson should parse stringified numbers', () {
      final jsonWithStrings = {
        'InstrumentId': 1,
        'LastTradedPx': '100.5',
        'Rolling24HrVolume': '2000.0',
        'Rolling24HrPxChange': '-2.5',
      };
      final result = QuoteModel.fromJson(jsonWithStrings);
      expect(result, quoteModel);
    });

    test('toEntity should return a valid QuoteEntity', () {
      final entity = quoteModel.toEntity();
      expect(entity, isA<QuoteEntity>());
      expect(entity.instrumentId, quoteModel.instrumentId);
      expect(entity.lastTradedPx, quoteModel.lastTradedPx);
      expect(entity.rolling24HrVolume, quoteModel.rolling24HrVolume);
      expect(entity.rolling24HrPxChange, quoteModel.rolling24HrPxChange);
    });

    test('props should contain all properties', () {
      expect(
        quoteModel.props,
        [1, 100.5, 2000.0, -2.5],
      );
    });
  });
}
