import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxbit_hiring_test_template/core/di/app_di.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/instrument_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/entities/quote_entity.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/instruments/instruments_cubit.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/instruments/instruments_state.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/quotes/quotes_cubit.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/quotes/quotes_state.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/item_widget.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/states/empty_state_widget.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/states/error_state_widget.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/widgets/states/loading_state_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InstrumentsCubit>(
          create: (_) => AppDI.I.get<InstrumentsCubit>()..getInstruments(),
        ),
        BlocProvider<QuotesCubit>(
          create: (_) => AppDI.I.get<QuotesCubit>(),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cotação',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SizedBox.expand(
            child: BlocBuilder<InstrumentsCubit, InstrumentsState>(
              builder: (context, instrumentsState) {
                switch (instrumentsState) {
                  case InstrumentsInitialState():
                  case InstrumentsLoadingState():
                    return const LoadingStateWidget();
                  case InstrumentsEmptyState():
                    return EmptyStateWidget(
                      onRefresh:
                          context.read<InstrumentsCubit>().getInstruments,
                    );
                  case InstrumentsErrorState():
                    return ErrorStateWidget(
                      onRefresh:
                          context.read<InstrumentsCubit>().getInstruments,
                    );
                  case InstrumentsLoadedState():
                    final List<InstrumentEntity> instruments =
                        instrumentsState.instruments;

                    return BlocBuilder<QuotesCubit, QuotesState>(
                      builder: (context, quotesState) {
                        if (quotesState is QuotesErrorState) {
                          return ErrorStateWidget(
                            onRefresh:
                                context.read<InstrumentsCubit>().getInstruments,
                          );
                        }

                        final Map<int, QuoteEntity> currentQuotes =
                            quotesState is QuotesUpdatedState
                                ? quotesState.quotes
                                : {};

                        return ListView.builder(
                          itemCount: instruments.length,
                          itemBuilder: (context, index) {
                            final InstrumentEntity instrument =
                                instruments[index];
                            final QuoteEntity? quote =
                                currentQuotes[instrument.instrumentId];

                            return ItemWidget(
                              instrument: instrument,
                              quote: quote,
                            );
                          },
                        );
                      },
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
