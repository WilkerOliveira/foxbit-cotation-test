import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/usecases/get_instruments_usecase.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/quotes/quotes_cubit.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/quotes/quotes_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetInstrumentsUsecase extends Mock implements GetInstrumentsUsecase {}

void main() {
  late QuotesCubit cubit;
  late GetInstrumentsUsecase mockUsecase;
  late StreamController<Map<int, QuoteEntity>> streamController;

  const testQuotes = {
    1: QuoteEntity(
      instrumentId: 1,
      lastTradedPx: 2,
      rolling24HrVolume: 3,
      rolling24HrPxChange: 4,
    ),
  };

  setUp(() {
    mockUsecase = MockGetInstrumentsUsecase();

    streamController = StreamController<Map<int, QuoteEntity>>.broadcast();

    when(() => mockUsecase.quotes).thenAnswer((_) => streamController.stream);
  });

  tearDown(() {
    cubit.close();
    streamController.close();
  });

  group('Initialization', () {
    test('should emit initial state when created', () {
      cubit = QuotesCubit(mockUsecase);
      expect(cubit.state, isA<QuotesInitialState>());
    });

    test('should listen to quotes stream on initialization', () async {
      cubit = QuotesCubit(mockUsecase);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<QuotesUpdatedState>(),
        ]),
      );

      streamController.add(testQuotes);
      await Future.delayed(Duration.zero);
    });
  });

  group('Stream Listening', () {
    setUp(() {
      cubit = QuotesCubit(mockUsecase);
    });

    test('should emit updated state with new quotes', () async {
      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<QuotesUpdatedState>(),
        ]),
      );

      streamController.add(testQuotes);
      await Future.delayed(Duration.zero);

      final state = cubit.state as QuotesUpdatedState;
      expect(state.quotes, testQuotes);
    });

    test('should handle empty quotes', () async {
      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<QuotesUpdatedState>(),
        ]),
      );

      streamController.add({});
      await Future.delayed(Duration.zero);

      final state = cubit.state as QuotesUpdatedState;
      expect(state.quotes, isEmpty);
    });

    test('should handle multiple quote updates', () async {
      final secondQuoteUpdate = {
        2: const QuoteEntity(
          instrumentId: 2,
          lastTradedPx: 3,
          rolling24HrVolume: 4,
          rolling24HrPxChange: 5,
        ),
      };

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<QuotesUpdatedState>(),
          isA<QuotesUpdatedState>(),
        ]),
      );

      streamController.add(testQuotes);
      streamController.add(secondQuoteUpdate);
      await Future.delayed(Duration.zero);

      final state = cubit.state as QuotesUpdatedState;
      expect(state.quotes, secondQuoteUpdate);
    });
  });
}
