import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/features/card/amwal_salebycard_sdk.dart';
import 'package:amwal_pay_sdk/features/transaction/data/repository/transaction_repository_impl.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/repository/transaction_repository.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/use_case/get_transaction_by_Id.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';

enum _TransactionModuleScope {
  card,
  wallet,
  both,
}

class TransactionModule {
  final NetworkService networkService;
  // ignore: library_private_types_in_public_api
  final _TransactionModuleScope scope;

  TransactionModule.card(this.networkService)
      : scope = _TransactionModuleScope.card;
  TransactionModule.wallet(this.networkService)
      : scope = _TransactionModuleScope.wallet;
  TransactionModule.both(this.networkService)
      : scope = _TransactionModuleScope.both;

  setup() {
    switch (scope) {
      case _TransactionModuleScope.card:
        return _registerForCard();
      case _TransactionModuleScope.wallet:
        return _registerForWallet();
      case _TransactionModuleScope.both:
        {
          _registerForCard();
          _registerForWallet();
        }
    }
  }

  void _registerForCard() {
    final getIt = CardInjector.instance.getIt;
    CardInjector.instance.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(networkService),
    );
    CardInjector.instance.registerLazySingleton<GetOneTransactionByIdUseCase>(
      () => GetOneTransactionByIdUseCase(getIt<TransactionRepository>()),
    );
  }

  void _registerForWallet() {
    final getIt = WalletInjector.instance.getIt;

    WalletInjector.instance.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(networkService),
    );
    WalletInjector.instance.registerLazySingleton<GetOneTransactionByIdUseCase>(
      () => GetOneTransactionByIdUseCase(getIt<TransactionRepository>()),
    );
  }
}
