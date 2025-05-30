import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/repositories/home_repository.dart';
import 'package:foxbit_hiring_test_template/utils/enums.dart';
import 'package:result_dart/result_dart.dart';

abstract class GetInstrumentsUsecase {
  Result<bool> call();
  void dispose();
  Stream<List<InstrumentEntity>> get instruments;
  Stream<Map<int, QuoteEntity>> get quotes;
}

class GetInstrumentsUsecaseImpl implements GetInstrumentsUsecase {
  GetInstrumentsUsecaseImpl(this._repository);

  final HomeRepository _repository;

  @override
  Stream<List<InstrumentEntity>> get instruments => _repository.instruments;
  @override
  Stream<Map<int, QuoteEntity>> get quotes => _repository.quotes;

  @override
  Result<bool> call() {
    try {
      _repository.getInstruments(
        [
          Instruments.bitcoin.instrumentId,
          Instruments.xrp.instrumentId,
          Instruments.trueUSD.instrumentId,
          Instruments.ethereum.instrumentId,
          Instruments.litecoin.instrumentId,
        ],
      );
      return const Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  void dispose() {
    _repository.dispose();
  }
}
