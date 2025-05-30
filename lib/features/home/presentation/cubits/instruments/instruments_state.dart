import 'package:equatable/equatable.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';

sealed class InstrumentsState extends Equatable {}

class InstrumentsInitialState extends InstrumentsState {
  @override
  List<Object?> get props => [];
}

class InstrumentsLoadingState extends InstrumentsState {
  @override
  List<Object?> get props => [];
}

class InstrumentsLoadedState extends InstrumentsState {
  InstrumentsLoadedState({required this.instruments});
  final List<InstrumentEntity> instruments;

  @override
  List<Object?> get props => [instruments];
}

class InstrumentsErrorState extends InstrumentsState {
  @override
  List<Object?> get props => [];
}

class InstrumentsEmptyState extends InstrumentsState {
  @override
  List<Object?> get props => [];
}
