import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/icon_widget.dart';
import 'package:foxbit_hiring_test_template/utils/enums.dart';
import 'package:foxbit_hiring_test_template/utils/formatter.dart';
import 'package:foxbit_hiring_test_template/utils/number_extension.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.instrument, this.quote});

  final InstrumentEntity instrument;
  final QuoteEntity? quote;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
          children: [
            IconWidget(
              instrumentId: instrument.instrumentId,
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Instruments.getName(
                      instrument.instrumentId,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    instrument.abreviation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (quote != null)
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatVariationPrice(quote!.rolling24HrPxChange),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: quote!.rolling24HrPxChange >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      quote!.lastTradedPx.formatToCurrency(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
