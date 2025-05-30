import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/core/exceptions/app_exceptions.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/repositories/home_repository.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/usecases/get_instruments_usecase.dart';
import 'package:foxbit_hiring_test_template/utils/enums.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late GetInstrumentsUsecase usecase;

  setUp(() {
    mockRepository = MockHomeRepository();
    usecase = GetInstrumentsUsecaseImpl(mockRepository);
  });

  test(
      'call should invoke getInstruments with correct ids and return Success(true)',
      () {
    when(() => mockRepository.getInstruments(any())).thenReturn(null);

    final result = usecase.call();

    expect(result, const Success(true));
    verify(
      () => mockRepository.getInstruments([
        Instruments.bitcoin.instrumentId,
        Instruments.xrp.instrumentId,
        Instruments.trueUSD.instrumentId,
        Instruments.ethereum.instrumentId,
        Instruments.litecoin.instrumentId,
      ]),
    ).called(1);
  });

  test(
      'call should return Failure when repository throws CouldNotGetInstrumentsException',
      () {
    when(() => mockRepository.getInstruments(any()))
        .thenThrow(CouldNotGetInstrumentsException('error'));

    final result = usecase.call();

    expect(result.isError(), true);
    expect(result.exceptionOrNull(), isA<CouldNotGetInstrumentsException>());
  });

  test(
      'call should return Failure when repository throws CouldNotGetQuotesException',
      () {
    when(() => mockRepository.getInstruments(any()))
        .thenThrow(CouldNotGetQuotesException('error'));

    final result = usecase.call();

    expect(result.isError(), true);
    expect(result.exceptionOrNull(), isA<CouldNotGetQuotesException>());
  });

  test('dispose should call repository.dispose', () {
    when(() => mockRepository.dispose()).thenReturn(null);

    usecase.dispose();

    verify(() => mockRepository.dispose()).called(1);
  });

  test('instruments stream should be proxied from repository', () {
    const stream = Stream<List<InstrumentEntity>>.empty();
    when(() => mockRepository.instruments).thenAnswer((_) => stream);

    expect(usecase.instruments, stream);
  });

  test('quotes stream should be proxied from repository', () {
    const stream = Stream<Map<int, QuoteEntity>>.empty();
    when(() => mockRepository.quotes).thenAnswer((_) => stream);

    expect(usecase.quotes, stream);
  });
}
