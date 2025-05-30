import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/features/home/data/datasource/home_datasource.dart';
import 'package:foxbit_hiring_test_template/features/home/data/repositories/home_repository_impl.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/repositories/home_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeDatasource extends Mock implements HomeDatasource {}

void main() {
  late HomeRepository repository;
  late HomeDatasource mockDatasource;
  late StreamController<Map<String, dynamic>> websocketStreamController;

  setUp(() {
    mockDatasource = MockHomeDatasource();

    websocketStreamController = StreamController<Map<String, dynamic>>();
    when(() => mockDatasource.getInstruments())
        .thenAnswer((_) => websocketStreamController.stream);

    when(() => mockDatasource.subscribeToQuote(any())).thenReturn(null);
    when(() => mockDatasource.dispose()).thenReturn(null);

    repository = HomeRepositoryImpl(mockDatasource);
  });

  tearDown(() async {
    await websocketStreamController.close();
    repository.dispose();
  });

  group('Repository tests', () {
    test(
        'should emit list of instruments when getInstruments succeeds with valid data',
        () async {
      final List<Map<String, dynamic>> validInstrumentsJson = [
        {"OMSId": 1, "InstrumentId": 1, "Symbol": "BTC/BRL", "SortIndex": 0},
        {"OMSId": 1, "InstrumentId": 2, "Symbol": "ETH/BRL", "SortIndex": 1},
        {"OMSId": 1, "InstrumentId": 3, "Symbol": "LTC/BRL", "SortIndex": 2},
      ];

      final List<InstrumentEntity> expectedInstruments = [
        const InstrumentEntity(
          instrumentId: 1,
          symbol: "BTC/BRL",
          sortIndex: 0,
          abreviation: '',
        ),
        const InstrumentEntity(
          instrumentId: 2,
          symbol: "ETH/BRL",
          sortIndex: 1,
          abreviation: '',
        ),
        const InstrumentEntity(
          instrumentId: 3,
          symbol: "LTC/BRL",
          sortIndex: 2,
          abreviation: '',
        ),
      ];

      repository.getInstruments([1, 2, 3]);

      expectLater(
        repository.instruments,
        emitsInOrder([
          [],
          expectedInstruments,
        ]),
      );

      websocketStreamController.add({
        'n': 'getInstruments',
        'o': jsonEncode(validInstrumentsJson),
      });

      await Future.delayed(Duration.zero);

      for (final instrument in expectedInstruments) {
        verify(() => mockDatasource.subscribeToQuote(instrument.instrumentId))
            .called(1);
      }
    });

    test(
        'should filter instruments by instrumentsId when getInstruments succeeds',
        () async {
      final List<Map<String, dynamic>> allInstrumentsJson = [
        {
          "OMSId": 1,
          "InstrumentId": 1,
          "Symbol": "BTC/BRL",
          "SortIndex": 0,
        },
        {
          "OMSId": 1,
          "InstrumentId": 99,
          "Symbol": "XYZ/BRL",
          "SortIndex": 0,
        },
        {
          "OMSId": 1,
          "InstrumentId": 2,
          "Symbol": "ETH/BRL",
          "SortIndex": 1,
        },
      ];

      final List<InstrumentEntity> expectedFilteredInstruments = [
        const InstrumentEntity(
          instrumentId: 1,
          symbol: "BTC/BRL",
          sortIndex: 0,
          abreviation: '',
        ),
        const InstrumentEntity(
          instrumentId: 2,
          symbol: "ETH/BRL",
          sortIndex: 1,
          abreviation: '',
        ),
      ];

      repository.getInstruments([1, 2]);

      expectLater(
        repository.instruments,
        emitsInOrder([
          [],
          expectedFilteredInstruments,
        ]),
      );

      websocketStreamController.add({
        'n': 'getInstruments',
        'o': jsonEncode(allInstrumentsJson),
      });

      await Future.delayed(Duration.zero);

      for (final instrument in expectedFilteredInstruments) {
        verify(() => mockDatasource.subscribeToQuote(instrument.instrumentId))
            .called(1);
      }
    });

    test('should emit quote when SubscribeLevel1 message is valid', () async {
      final Map<String, dynamic> validQuoteJson = {
        "InstrumentId": 1,
        "LastTradedPx": 20,
        "Rolling24HrPxChange": 15,
        "Rolling24HrVolume": 0.7,
      };

      const QuoteEntity expectedQuote = QuoteEntity(
        instrumentId: 1,
        lastTradedPx: 20,
        rolling24HrPxChange: 15,
        rolling24HrVolume: 0.7,
      );

      expectLater(
        repository.quotes,
        emitsInOrder([
          {},
          {1: expectedQuote},
        ]),
      );

      repository.getInstruments([1]);

      websocketStreamController.add({
        'n': 'SubscribeLevel1',
        'o': jsonEncode(validQuoteJson),
      });

      await Future.delayed(Duration.zero);
      await websocketStreamController.close();
    });

    test('should emit quote when Level1UpdateEvent message is valid', () async {
      final Map<String, dynamic> validQuoteJson = {
        "InstrumentId": 1,
        "LastTradedPx": 30,
        "Rolling24HrPxChange": 18,
        "Rolling24HrVolume": 0.7,
      };

      const QuoteEntity expectedQuote = QuoteEntity(
        instrumentId: 1,
        lastTradedPx: 30,
        rolling24HrPxChange: 18,
        rolling24HrVolume: 0.7,
      );

      expectLater(
        repository.quotes,
        emitsInOrder([
          {},
          {1: expectedQuote},
        ]),
      );

      repository.getInstruments([1]);

      websocketStreamController.add({
        'n': 'Level1UpdateEvent',
        'o': jsonEncode(validQuoteJson),
      });

      await Future.delayed(Duration.zero);
      await websocketStreamController.close();
    });
  });
}
