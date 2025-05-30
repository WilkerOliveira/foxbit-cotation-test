import 'package:equatable/equatable.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';

class QuoteModel extends Equatable {
  const QuoteModel({
    required this.instrumentId,
    required this.lastTradedPx,
    required this.rolling24HrVolume,
    required this.rolling24HrPxChange,
  });

  final int instrumentId;
  final double lastTradedPx;
  final double rolling24HrVolume;
  final double rolling24HrPxChange;

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      instrumentId: json['InstrumentId'] as int,
      lastTradedPx: num.parse(json['LastTradedPx'].toString()).toDouble(),
      rolling24HrVolume:
          num.parse(json['Rolling24HrVolume'].toString()).toDouble(),
      rolling24HrPxChange:
          num.parse(json['Rolling24HrPxChange'].toString()).toDouble(),
    );
  }

  QuoteEntity toEntity() {
    return QuoteEntity(
      instrumentId: instrumentId,
      lastTradedPx: lastTradedPx,
      rolling24HrVolume: rolling24HrVolume,
      rolling24HrPxChange: rolling24HrPxChange,
    );
  }

  @override
  List<Object?> get props =>
      [instrumentId, lastTradedPx, rolling24HrVolume, rolling24HrPxChange];
}
