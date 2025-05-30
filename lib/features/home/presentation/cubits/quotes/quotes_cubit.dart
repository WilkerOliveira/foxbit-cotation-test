import 'package:bloc/bloc.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/usecases/get_instruments_usecase.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/quotes/quotes_state.dart';

class QuotesCubit extends Cubit<QuotesState> {
  QuotesCubit(this._getInstrumentsUsecase) : super(QuotesInitialState()) {
    _getInstrumentsUsecase.quotes.listen(
      (quotes) {
        emit(QuotesUpdatedState(quotes));
      },
    );
  }

  final GetInstrumentsUsecase _getInstrumentsUsecase;
}
