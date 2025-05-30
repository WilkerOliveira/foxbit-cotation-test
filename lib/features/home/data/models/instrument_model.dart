import 'package:equatable/equatable.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';

class InstrumentModel extends Equatable {
  const InstrumentModel({
    required this.instrumentId,
    required this.symbol,
    required this.sortIndex,
    required this.abreviation,
  });

  final int instrumentId;
  final String symbol;
  final int sortIndex;
  final String abreviation;

  factory InstrumentModel.fromJson(Map<dynamic, dynamic> json) {
    return InstrumentModel(
      instrumentId: json['InstrumentId'] as int,
      symbol: json['Symbol'] as String,
      sortIndex: json['SortIndex'] as int,
      abreviation: json['Product1Symbol'] != null
          ? json['Product1Symbol'] as String
          : '',
    );
  }

  InstrumentEntity toEntity() {
    return InstrumentEntity(
      instrumentId: instrumentId,
      symbol: symbol,
      sortIndex: sortIndex,
      abreviation: abreviation,
    );
  }

  @override
  List<Object?> get props => [
        instrumentId,
        symbol,
        sortIndex,
        abreviation,
      ];
}
