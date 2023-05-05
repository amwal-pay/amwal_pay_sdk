

import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/core/ui/amountcurrencywidget/amount_currency_widget_cubit.dart';
import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_manual_cubit.dart';
import 'package:amwal_pay_sdk/features/card/data/repository/sale_by_card_repository.dart';
import 'package:amwal_pay_sdk/features/card/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/card/domain/repository/sale_by_card_repo.dart';
import 'package:amwal_pay_sdk/features/card/domain/use_case/purchase_otp_step_one_use_case.dart';
import 'package:amwal_pay_sdk/features/card/domain/use_case/purchase_otp_step_two_use_case.dart';
import 'package:amwal_pay_sdk/features/card/domain/use_case/purchase_use_case.dart';

class SaleByCardModule {
  final NetworkService _networkService;
  SaleByCardModule(this._networkService);

  setup() {
    final getIt = CardInjector.instance.getIt;

    /// inject card repository
    CardInjector.instance.registerLazySingleton<ISaleByCardRepository>(
      () => SaleByCardRepositoryImpl(
        _networkService,
      ),
    );

    /// inject sale by card use cases
    CardInjector.instance.registerLazySingleton(
      () => PurchaseUseCase(
        getIt<ISaleByCardRepository>(),
      ),
    );
    CardInjector.instance.registerLazySingleton(
      () => PurchaseOtpStepOneUseCase(
        getIt<ISaleByCardRepository>(),
      ),
    );
    CardInjector.instance.registerLazySingleton(
      () => PurchaseOtpStepTwoUseCase(
        getIt<ISaleByCardRepository>(),
      ),
    );

    /// inject sale by card cubit
    CardInjector.instance.registerLazySingleton(
      () => SaleByCardManualCubit(
        getIt<PurchaseUseCase>(),
        getIt<PurchaseOtpStepOneUseCase>(),
        getIt<PurchaseOtpStepTwoUseCase>(),
      ),
    );

    /// inject amount card cubit
    CardInjector.instance.registerLazySingleton(
      () => AmountCurrencyWidgetCubit(),
    );
  }
}
