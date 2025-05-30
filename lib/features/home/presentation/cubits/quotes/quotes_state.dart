import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';

abstract class QuotesState {}

class QuotesInitialState extends QuotesState {}

class QuotesUpdatedState extends QuotesState {
  final Map<int, QuoteEntity> quotes;

  QuotesUpdatedState(this.quotes);
}

class QuotesErrorState extends QuotesState {}
