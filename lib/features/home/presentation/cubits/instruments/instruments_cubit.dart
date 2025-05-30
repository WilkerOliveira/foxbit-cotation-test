import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/usecases/get_instruments_usecase.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/instruments/instruments_state.dart';

class InstrumentsCubit extends Cubit<InstrumentsState> {
  bool _firstAttempt = true;

  InstrumentsCubit(this._getInstrumentsUsecase)
      : super(InstrumentsInitialState()) {
    _startListen();
  }

  final GetInstrumentsUsecase _getInstrumentsUsecase;

  void _startListen() {
    _getInstrumentsUsecase.instruments.listen(
      (instruments) {
        if (instruments.isNotEmpty) {
          emit(InstrumentsLoadedState(instruments: instruments));
        } else if (!_firstAttempt) {
          emit(InstrumentsEmptyState());
        }
        _firstAttempt = false;
      },
    );
  }

  void getInstruments() {
    emit(InstrumentsLoadingState());
    try {
      final result = _getInstrumentsUsecase();
      result.fold((onSuccess) {}, (onFailure) => emit(InstrumentsErrorState()));
    } on Exception catch (_) {
      emit(InstrumentsErrorState());
    }
  }

  @override
  Future<void> close() async {
    _getInstrumentsUsecase.dispose();
    super.close();
  }
}
