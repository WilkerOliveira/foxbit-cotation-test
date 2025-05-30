import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/icon_widget.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/item_widget.dart';
import 'package:foxbit_hiring_test_template/utils/enums.dart';

void main() {
  final instrument = InstrumentEntity(
    instrumentId: Instruments.bitcoin.instrumentId,
    abreviation: 'BTC',
    symbol: Instruments.bitcoin.name,
    sortIndex: 1,
  );

  final quote = QuoteEntity(
    instrumentId: Instruments.bitcoin.instrumentId,
    lastTradedPx: 50000.0,
    rolling24HrPxChange: 2.5,
    rolling24HrVolume: 4.1,
  );

  Widget createWidgetUnderTest(
    InstrumentEntity instrument,
    QuoteEntity? quote,
  ) {
    return MaterialApp(
      home: Scaffold(
        body: ItemWidget(
          instrument: instrument,
          quote: quote,
        ),
      ),
    );
  }

  testWidgets('renders ItemWidget with instrument only',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(instrument, null));

    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(IconWidget), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));
  });

  testWidgets(
      'renders ItemWidget with instrument and quote (positive variation)',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(instrument, quote));

    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.byType(IconWidget), findsOneWidget);
    expect(find.textContaining('+'), findsOneWidget);
    expect(find.textContaining('2.5'), findsOneWidget);
    final variationText = tester.widget<Text>(find.textContaining('+'));
    expect(variationText.style?.color, Colors.green);
  });

  testWidgets(
      'renders ItemWidget with instrument and quote (negative variation)',
      (WidgetTester tester) async {
    final quote = QuoteEntity(
      instrumentId: Instruments.bitcoin.instrumentId,
      lastTradedPx: 50000.0,
      rolling24HrPxChange: -1.27,
      rolling24HrVolume: 4.1,
    );

    await tester.pumpWidget(createWidgetUnderTest(instrument, quote));

    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.byType(IconWidget), findsOneWidget);
    expect(find.textContaining('-'), findsOneWidget);
    expect(find.textContaining('1.27'), findsOneWidget);
    final variationText = tester.widget<Text>(find.textContaining('-'));
    expect(variationText.style?.color, Colors.red);
  });
}
