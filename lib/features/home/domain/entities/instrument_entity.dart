import 'package:equatable/equatable.dart';

class InstrumentEntity extends Equatable {
  const InstrumentEntity({
    required this.instrumentId,
    required this.symbol,
    required this.sortIndex,
    required this.abreviation,
  });

  final int instrumentId;
  final String symbol;
  final int sortIndex;
  final String abreviation;

  @override
  List<Object?> get props => [
        instrumentId,
        symbol,
        sortIndex,
        abreviation,
      ];
}
