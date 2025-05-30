// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:convert';

import 'package:foxbit_hiring_test_template/core/exceptions/app_exceptions.dart';
import 'package:foxbit_hiring_test_template/features/home/data/datasource/home_datasource.dart';
import 'package:foxbit_hiring_test_template/features/home/data/models/instrument_model.dart';
import 'package:foxbit_hiring_test_template/features/home/data/models/quote_model.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/repositories/home_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._datasource);

  final HomeDatasource _datasource;

  final _instrumentsController =
      BehaviorSubject<List<InstrumentEntity>>.seeded([]);
  final _quotesController = BehaviorSubject<Map<int, QuoteEntity>>.seeded({});

  @override
  Stream<List<InstrumentEntity>> get instruments =>
      _instrumentsController.stream;
  @override
  Stream<Map<int, QuoteEntity>> get quotes => _quotesController.stream;
  List<int> instrumentsId = [];

  @override
  void getInstruments(List<int> instrumentsId) {
    this.instrumentsId = instrumentsId;
    final result = _datasource.getInstruments();
    result.listen(_handleWebSocketMessage);
  }

  void _handleWebSocketMessage(Map<String, dynamic> message) {
    final String methodName = message['n'] as String;
    final String rawData = message['o'] as String;

    if (methodName == 'SubscribeLevel1' || methodName == 'Level1UpdateEvent') {
      _handleSubscribeQuotes(rawData);
    } else {
      _handleGetInstruments(rawData);
    }
  }

  void _handleGetInstruments(String rawData) {
    try {
      final List<dynamic> jsonList = jsonDecode(rawData) as List;
      final instruments = jsonList
          .where((item) => instrumentsId.contains(item['InstrumentId'] as int))
          .map((json) {
        return InstrumentModel.fromJson(json as Map).toEntity();
      }).toList();

      _instrumentsController.add(instruments);

      _subscribeInstrumentsToQuotes(instruments);
    } on Object catch (e) {
      _instrumentsController.addError(
        CouldNotGetInstrumentsException(
          'Error parsing getInstruments data: $e',
        ),
      );
    }
  }

  void _handleSubscribeQuotes(String rawData) {
    try {
      final Map<String, dynamic> jsonMap =
          jsonDecode(rawData) as Map<String, dynamic>;

      final quote = QuoteModel.fromJson(jsonMap).toEntity();

      final currentQuotes = Map<int, QuoteEntity>.from(_quotesController.value);

      currentQuotes[quote.instrumentId] = quote;

      _quotesController.add(currentQuotes);
    } on Object catch (e) {
      _quotesController.addError(
        CouldNotGetQuotesException('Error parsing Quotes data: $e'),
      );
    }
  }

  void _subscribeInstrumentsToQuotes(List<InstrumentEntity> instruments) {
    for (final instrument in instruments) {
      _subscribeToQuote(instrument.instrumentId);
    }
  }

  void _subscribeToQuote(int instrumentId) {
    _datasource.subscribeToQuote(instrumentId);
  }

  @override
  void dispose() {
    _instrumentsController.close();
    _quotesController.close();
    _datasource.dispose();
  }
}
