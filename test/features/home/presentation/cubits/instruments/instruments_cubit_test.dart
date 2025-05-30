import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/core/exceptions/app_exceptions.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/usecases/get_instruments_usecase.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/instruments/instruments_cubit.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/instruments/instruments_state.dart';
import 'package:foxbit_hiring_test_template/utils/enums.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockGetInstrumentsUsecase extends Mock implements GetInstrumentsUsecase {}

void main() {
  late InstrumentsCubit cubit;
  late MockGetInstrumentsUsecase mockUsecase;
  late StreamController<List<InstrumentEntity>> streamController;

  final testInstruments = [
    InstrumentEntity(
      instrumentId: Instruments.bitcoin.instrumentId,
      symbol: 'BTC',
      sortIndex: 1,
      abreviation: Instruments.bitcoin.name,
    ),
    InstrumentEntity(
      instrumentId: Instruments.ethereum.instrumentId,
      symbol: 'ETH',
      sortIndex: 2,
      abreviation: Instruments.ethereum.name,
    ),
  ];

  setUp(() {
    mockUsecase = MockGetInstrumentsUsecase();
    streamController = StreamController<List<InstrumentEntity>>.broadcast();

    when(() => mockUsecase.instruments)
        .thenAnswer((_) => streamController.stream);
    when(() => mockUsecase.dispose()).thenAnswer((_) async {});

    cubit = InstrumentsCubit(mockUsecase);
  });

  tearDown(() {
    streamController.close();
    cubit.close();
  });

  group('Initialization', () {
    test('initial state should be InstrumentsInitialState', () {
      expect(cubit.state, isA<InstrumentsInitialState>());
    });

    test('should emit loaded state when instruments are received', () async {
      cubit = InstrumentsCubit(mockUsecase);

      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder([
            isA<InstrumentsLoadedState>(),
          ]),
        ),
      );

      streamController.add(testInstruments);

      await pumpEventQueue();

      final state = cubit.state as InstrumentsLoadedState;
      expect(state.instruments, testInstruments);
    });

    test('should emit nothing when the first empty return', () async {
      cubit = InstrumentsCubit(mockUsecase);

      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder([]),
        ),
      );

      streamController.add([]);
      await pumpEventQueue();
    });

    test('should emit empty state when empty list is received', () async {
      cubit = InstrumentsCubit(mockUsecase);

      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder([
            isA<InstrumentsEmptyState>(),
          ]),
        ),
      );

      streamController.add([]);
      streamController.add([]);
      await pumpEventQueue();
    });
  });

  group('getInstruments', () {
    blocTest<InstrumentsCubit, InstrumentsState>(
      'should emit loading state when called',
      setUp: () {
        when(() => mockUsecase()).thenAnswer((_) => const Success(true));
      },
      build: () => InstrumentsCubit(mockUsecase),
      act: (cubit) => cubit.getInstruments(),
      expect: () => [
        isA<InstrumentsLoadingState>(),
      ],
    );

    blocTest<InstrumentsCubit, InstrumentsState>(
      'should emit error state when usecase fails',
      setUp: () {
        when(() => mockUsecase())
            .thenAnswer((_) => Failure(AppException('error')));
      },
      build: () => InstrumentsCubit(mockUsecase),
      act: (cubit) => cubit.getInstruments(),
      expect: () => [
        isA<InstrumentsLoadingState>(),
        isA<InstrumentsErrorState>(),
      ],
    );

    blocTest<InstrumentsCubit, InstrumentsState>(
      'should emit error state when usecase throws exception',
      setUp: () {
        when(() => mockUsecase()).thenThrow(AppException('error'));
      },
      build: () => InstrumentsCubit(mockUsecase),
      act: (cubit) => cubit.getInstruments(),
      expect: () => [
        isA<InstrumentsLoadingState>(),
        isA<InstrumentsErrorState>(),
      ],
    );
  });

  group('Disposal', () {
    test('should close usecase when cubit is closed', () async {
      cubit = InstrumentsCubit(mockUsecase);
      await cubit.close();
      verify(() => mockUsecase.dispose()).called(1);
    });
  });
}

Future<void> pumpEventQueue() async {
  await Future.delayed(Duration.zero);
}
