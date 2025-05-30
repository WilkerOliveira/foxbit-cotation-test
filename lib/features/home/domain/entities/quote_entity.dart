import 'package:equatable/equatable.dart';

class QuoteEntity extends Equatable {
  const QuoteEntity({
    required this.instrumentId,
    required this.lastTradedPx,
    required this.rolling24HrVolume,
    required this.rolling24HrPxChange,
  });

  final int instrumentId;
  final double lastTradedPx;
  final double rolling24HrVolume;
  final double rolling24HrPxChange;

  @override
  List<Object?> get props =>
      [instrumentId, lastTradedPx, rolling24HrVolume, rolling24HrPxChange];
}
