import 'package:get_it/get_it.dart';

class CardInjector {
  const CardInjector._();
  static CardInjector get instance => const CardInjector._();
  static const cardScope = 'card_scope';
  GetIt get getIt => GetIt.instance;

  T get<T extends Object>() => getIt.get<T>();

  void registerLazySingleton<T extends Object>(T Function() function) {
    register<T>(() => getIt.registerLazySingleton<T>(function));
  }

  void register<T extends Object>(void Function() function) {
    if (!getIt.isRegistered<T>()) {
      function();
    }
  }

  Future<void> onSdkInit(Future<void> Function() sdkInit) async {
    try {
      if (getIt.currentScopeName == cardScope) {
        await getIt.resetScope();
      } else {
        getIt.pushNewScope(scopeName: cardScope);
      }
      await sdkInit();
    } catch (e) {
      if (getIt.currentScopeName == cardScope) {
        await getIt.resetScope();
      }
    }
  }
}
