// ignore_for_file: avoid_classes_with_only_static_members

import 'package:foxbit_hiring_test_template/core/connections/web_socket/websocket_connection.dart';
import 'package:foxbit_hiring_test_template/core/di/app_di.dart';
import 'package:foxbit_hiring_test_template/features/home/data/datasource/home_datasource.dart';
import 'package:foxbit_hiring_test_template/features/home/data/repositories/home_repository_impl.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/repositories/home_repository.dart';
import 'package:foxbit_hiring_test_template/features/home/domain/usecases/get_instruments_usecase.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/instruments/instruments_cubit.dart';
import 'package:foxbit_hiring_test_template/features/home/presentation/cubits/quotes/quotes_cubit.dart';

abstract class SetupDi {
  static void setup() {
    _registerCore();
    _registerDatasource();
    _registerRepository();
    _registerUsecase();
    _registerCubit();
  }

  static void _registerCore() {
    AppDI.I.registerSingleton<WebSocketConnection>(WebSocketConnectionImpl());
  }

  static void _registerDatasource() {
    AppDI.I.registerLazySingleton<HomeDatasource>(
      () => HomeDatasourceImpl(AppDI.I.get<WebSocketConnection>()),
    );
  }

  static void _registerRepository() {
    AppDI.I.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(AppDI.I.get<HomeDatasource>()),
    );
  }

  static void _registerUsecase() {
    AppDI.I.registerSingleton<GetInstrumentsUsecase>(
      GetInstrumentsUsecaseImpl(AppDI.I.get<HomeRepository>()),
    );
  }

  static void _registerCubit() {
    AppDI.I.registerFactory<InstrumentsCubit>(
      () => InstrumentsCubit(AppDI.I.get<GetInstrumentsUsecase>()),
    );
    AppDI.I.registerFactory<QuotesCubit>(
      () => QuotesCubit(AppDI.I.get<GetInstrumentsUsecase>()),
    );
  }
}
