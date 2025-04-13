import 'package:amwal_pay_sdk/features/digital_wallet/cubit/sale_by_digital_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/card/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/card/domain/repository/sale_by_card_repo.dart';
import 'package:amwal_pay_sdk/features/card/domain/use_case/purchase_apple_samsung_pay.dart';
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../card/data/repository/sale_by_card_repository.dart';
import '../../wallet/dependency/injector.dart';

class SaleByApplePayModule {
  final NetworkService _networkService;

  SaleByApplePayModule(this._networkService);

  void setup() {

    // Get the existing repository from CardInjector

    // Register the use case
    // WalletInjector.instance.getIt.registerLazySingleton<PurchaseAppleSamsungPayUseCase>(
    //       () => PurchaseAppleSamsungPayUseCase( WalletInjector.instance.getIt<ISaleByCardRepository>()),
    // );
    // WalletInjector.instance
    //     .getIt<PurchaseAppleSamsungPayUseCase>(),

  }

  // Factory method to create the cubit with all required dependencies
   createCubit({
    required BuildContext context,
    required Function(String) onResponse,
    required Function() dismissDialog,
    required Function(String) log,
  }) {



    if (!WalletInjector.instance.getIt.isRegistered<SaleByCardRepositoryImpl>()) {
      WalletInjector.instance.getIt.registerLazySingleton<SaleByCardRepositoryImpl>(
            () => SaleByCardRepositoryImpl(WalletInjector.instance.getIt<NetworkService>()),
      );
    }

    if (!WalletInjector.instance.getIt.isRegistered<PurchaseAppleSamsungPayUseCase>()) {
      WalletInjector.instance.getIt.registerLazySingleton<PurchaseAppleSamsungPayUseCase>(
            () => PurchaseAppleSamsungPayUseCase(WalletInjector.instance.getIt<SaleByCardRepositoryImpl>()),
      );
    }



    if (!WalletInjector.instance.getIt.isRegistered<SaleByDigitalWalletCubit>()) {
      WalletInjector.instance.getIt.registerLazySingleton<SaleByDigitalWalletCubit>(
            () => SaleByDigitalWalletCubit(
              context: context,
              onResponse: onResponse,
              dismissDialog: dismissDialog,
              log: log,
              purchaseAppleSamsungPayUseCase: WalletInjector.instance
                  .getIt<PurchaseAppleSamsungPayUseCase>(),
            ),
      );
    }



  }
}

