import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class AppDI {
  AppDI._internal();
  static AppDI _instance = AppDI._internal();
  static AppDI get I => _instance;

  void registerLazySingleton<T extends Object>(T Function() factory) {
    GetIt.I.registerLazySingleton<T>(factory);
  }

  void registerFactory<T extends Object>(T Function() factory) {
    GetIt.I.registerFactory<T>(factory);
  }

  void registerSingleton<T extends Object>(T instance) {
    GetIt.I.registerSingleton<T>(instance);
  }

  T get<T extends Object>() {
    return GetIt.I.get<T>();
  }

  T call<T extends Object>() {
    return GetIt.I<T>();
  }

  void reset() {
    GetIt.I.reset();
  }

  void unregister<T extends Object>() {
    GetIt.I.unregister<T>();
  }

  @visibleForTesting
  static void enableTestMode({bool reset = true}) {
    if (reset) {
      GetIt.I.reset();
    }
    _instance = AppDI._internal();
  }
}
