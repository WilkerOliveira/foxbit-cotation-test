import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/core/di/app_di.dart';
import 'package:foxbit_hiring_test_template/core/di/setup_di.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/instruments/instruments_cubit.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/instruments/instruments_state.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/quotes/quotes_cubit.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/quotes/quotes_state.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/pages/home_page.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/item_widget.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/refresh_button_widget.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/states/empty_state_widget.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/states/error_state_widget.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/states/loading_state_widget.dart';
import 'package:foxbit_hiring_test_template/utils/enums.dart';
import 'package:foxbit_hiring_test_template/utils/formatter.dart';
import 'package:foxbit_hiring_test_template/utils/number_extension.dart';
import 'package:mocktail/mocktail.dart';

class MockInstrumentsCubit extends MockCubit<InstrumentsState>
    implements InstrumentsCubit {}

class MockQuotesCubit extends MockCubit<QuotesState> implements QuotesCubit {}

void main() {
  late MockInstrumentsCubit mockInstrumentsCubit;
  late MockQuotesCubit mockQuotesCubit;

  final instruments = [
    InstrumentEntity(
      instrumentId: Instruments.bitcoin.instrumentId,
      abreviation: 'BTC',
      symbol: Instruments.bitcoin.name,
      sortIndex: 1,
    ),
    InstrumentEntity(
      instrumentId: Instruments.ethereum.instrumentId,
      abreviation: 'ETH',
      symbol: Instruments.ethereum.name,
      sortIndex: 2,
    ),
    InstrumentEntity(
      instrumentId: Instruments.litecoin.instrumentId,
      abreviation: 'LTC',
      symbol: Instruments.litecoin.name,
      sortIndex: 3,
    ),
  ];

  final quotes = {
    1: QuoteEntity(
      instrumentId: Instruments.bitcoin.instrumentId,
      lastTradedPx: 50000.0,
      rolling24HrPxChange: 2.5,
      rolling24HrVolume: 4.1,
    ),
    2: QuoteEntity(
      instrumentId: Instruments.ethereum.instrumentId,
      lastTradedPx: 3000.0,
      rolling24HrPxChange: -1.2,
      rolling24HrVolume: 2.3,
    ),
    3: QuoteEntity(
      instrumentId: Instruments.litecoin.instrumentId,
      lastTradedPx: 150.0,
      rolling24HrPxChange: 0.0,
      rolling24HrVolume: 1.6,
    ),
  };

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    AppDI.I.reset();
    SetupDi.setup();

    mockInstrumentsCubit = MockInstrumentsCubit();
    mockQuotesCubit = MockQuotesCubit();

    AppDI.I.unregister<InstrumentsCubit>();
    AppDI.I.unregister<QuotesCubit>();
    AppDI.I.registerFactory<InstrumentsCubit>(() => mockInstrumentsCubit);
    AppDI.I.registerFactory<QuotesCubit>(() => mockQuotesCubit);

    when(() => mockInstrumentsCubit.getInstruments()).thenAnswer((_) async {});
  });

  tearDown(() {
    mockInstrumentsCubit.close();
    mockQuotesCubit.close();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: HomePage(),
    );
  }

  group('HomePage Widget Tests', () {
    testWidgets('should show LoadingStateWidget when InstrumentsInitialState',
        (WidgetTester tester) async {
      when(() => mockInstrumentsCubit.state)
          .thenReturn(InstrumentsInitialState());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(LoadingStateWidget), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(EmptyStateWidget), findsNothing);
      expect(find.byType(ErrorStateWidget), findsNothing);
    });

    testWidgets('should show LoadingStateWidget when InstrumentsLoadingState',
        (WidgetTester tester) async {
      when(() => mockInstrumentsCubit.state)
          .thenReturn(InstrumentsLoadingState());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(LoadingStateWidget), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(EmptyStateWidget), findsNothing);
      expect(find.byType(ErrorStateWidget), findsNothing);
    });

    testWidgets('should show EmptyStateWidget when InstrumentsEmptyState',
        (WidgetTester tester) async {
      when(() => mockInstrumentsCubit.state)
          .thenReturn(InstrumentsEmptyState());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.byType(LoadingStateWidget), findsNothing);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(ErrorStateWidget), findsNothing);
    });

    testWidgets('should show ErrorStateWidget when InstrumentsErrorState',
        (WidgetTester tester) async {
      when(() => mockInstrumentsCubit.state)
          .thenReturn(InstrumentsErrorState());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ErrorStateWidget), findsOneWidget);
      expect(find.byType(LoadingStateWidget), findsNothing);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(EmptyStateWidget), findsNothing);
    });

    testWidgets(
        'should show ListView with instruments when InstrumentsLoadedState and QuotesInitialState',
        (WidgetTester tester) async {
      when(() => mockInstrumentsCubit.state)
          .thenReturn(InstrumentsLoadedState(instruments: instruments));
      when(() => mockQuotesCubit.state).thenReturn(QuotesInitialState());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ItemWidget), findsNWidgets(instruments.length));

      expect(find.text(Instruments.getName(1)), findsOneWidget);
      expect(find.text('BTC'), findsOneWidget);
      expect(find.text(Instruments.getName(4)), findsOneWidget);
      expect(find.text('ETH'), findsOneWidget);

      expect(find.text('+0.00%'), findsNothing);
      expect(find.text('R\$0,00'), findsNothing);
    });

    testWidgets(
        'should show ListView with instruments and quotes when InstrumentsLoadedState and QuotesUpdatedState',
        (WidgetTester tester) async {
      when(() => mockInstrumentsCubit.state)
          .thenReturn(InstrumentsLoadedState(instruments: instruments));
      when(() => mockQuotesCubit.state).thenReturn(QuotesUpdatedState(quotes));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ItemWidget), findsNWidgets(instruments.length));

      for (var i = 0; i < instruments.length; i++) {
        final instrument = instruments[i];
        final quote = quotes[instrument.instrumentId];

        final itemFinder = find.byWidgetPredicate(
          (widget) =>
              widget is ItemWidget &&
              widget.instrument.instrumentId == instrument.instrumentId,
        );
        expect(itemFinder, findsOneWidget);

        expect(
          find.descendant(
            of: itemFinder,
            matching: find.text(Instruments.getName(instrument.instrumentId)),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: itemFinder,
            matching: find.text(instrument.abreviation),
          ),
          findsOneWidget,
        );

        if (quote != null) {
          expect(
            find.descendant(
              of: itemFinder,
              matching:
                  find.text(formatVariationPrice(quote.rolling24HrPxChange)),
            ),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: itemFinder,
              matching: find.text(quote.lastTradedPx.formatToCurrency()),
            ),
            findsOneWidget,
          );

          final variationText = tester.widget<Text>(
            find.descendant(
              of: itemFinder,
              matching:
                  find.text(formatVariationPrice(quote.rolling24HrPxChange)),
            ),
          );
          if (quote.rolling24HrPxChange >= 0) {
            expect(variationText.style?.color, Colors.green);
          } else {
            expect(variationText.style?.color, Colors.red);
          }
        }
      }
    });

    testWidgets(
        'should show ErrorStateWidget when QuotesErrorState, even if instruments are loaded',
        (WidgetTester tester) async {
      when(() => mockInstrumentsCubit.state)
          .thenReturn(InstrumentsLoadedState(instruments: instruments));
      when(() => mockQuotesCubit.state).thenReturn(QuotesErrorState());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ErrorStateWidget), findsOneWidget);
      expect(
        find.byType(ListView),
        findsNothing,
      );
    });

    testWidgets('should call getInstruments on refresh in EmptyStateWidget',
        (WidgetTester tester) async {
      when(() => mockInstrumentsCubit.state)
          .thenReturn(InstrumentsEmptyState());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(
        find.text(
          'Não encontramos nenhuma moeda no momento. Tentar novamente?',
        ),
        findsOneWidget,
      );
      expect(find.byType(RefreshButtonWidget), findsOneWidget);

      await tester.tap(find.byType(RefreshButtonWidget));
      await tester.pumpAndSettle();

      verify(() => mockInstrumentsCubit.getInstruments()).called(2);
    });

    testWidgets(
        'should call getInstruments on refresh in ErrorStateWidget (Instruments)',
        (WidgetTester tester) async {
      when(() => mockInstrumentsCubit.state)
          .thenReturn(InstrumentsErrorState());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ErrorStateWidget), findsOneWidget);
      expect(
        find.text(
          'Ops, algo de errado aconteceu!\nTente novamente.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.byType(RefreshButtonWidget));
      await tester.pumpAndSettle();

      verify(() => mockInstrumentsCubit.getInstruments()).called(2);
    });

    testWidgets(
        'should call getInstruments on refresh in ErrorStateWidget (Quotes)',
        (WidgetTester tester) async {
      when(() => mockInstrumentsCubit.state)
          .thenReturn(InstrumentsLoadedState(instruments: instruments));
      when(() => mockQuotesCubit.state).thenReturn(QuotesErrorState());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ErrorStateWidget), findsOneWidget);

      await tester.tap(find.byType(RefreshButtonWidget));
      await tester.pumpAndSettle();

      verify(() => mockInstrumentsCubit.getInstruments()).called(2);
    });
  });
}
