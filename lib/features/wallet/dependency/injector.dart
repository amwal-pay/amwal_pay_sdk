import 'package:get_it/get_it.dart';

class WalletInjector {
  const WalletInjector._();

  static WalletInjector get instance => const WalletInjector._();
  static const walletScope = 'wallet_scope';

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
      if (getIt.currentScopeName == walletScope) {
        await getIt.resetScope();
      } else {
        getIt.pushNewScope(scopeName: walletScope);
      }
      await sdkInit();
    } catch (e, s) {
      if (getIt.currentScopeName == walletScope) {
        await getIt.resetScope();
      }
      print('Exception is $s');
      print('Exception2 is $e');
    }
  }
}
