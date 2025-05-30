import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';

abstract class HomeRepository {
  Stream<List<InstrumentEntity>> get instruments;
  Stream<Map<int, QuoteEntity>> get quotes;
  void getInstruments(List<int> instrumentsId);
  void dispose();
}
