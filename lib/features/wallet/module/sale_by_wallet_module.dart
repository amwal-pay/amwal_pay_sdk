import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_qr_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_pay_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_verify_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/request/payment_request.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/qr_response.dart';
import 'package:amwal_pay_sdk/features/wallet/data/repository/sale_by_wallet_repo_imp.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/wallet/domain/sale_by_wallet_repository.dart';
import 'package:amwal_pay_sdk/features/wallet/domain/use_case/pay_with_alias_use_case.dart';
import 'package:amwal_pay_sdk/features/wallet/domain/use_case/pay_with_mobile_use_case.dart';
import 'package:amwal_pay_sdk/features/wallet/domain/use_case/pay_with_qr_use_case.dart';
import 'package:amwal_pay_sdk/features/wallet/domain/use_case/verify_customer_use_case.dart';


class SaleByWalletModule {
  final NetworkService _networkService;
  SaleByWalletModule(this._networkService);

  void setup() {
    final getIt = WalletInjector.instance.getIt;
    WalletInjector.instance.registerLazySingleton<SaleByWalletRepository>(
      () => SaleByWalletRepoImpl(
        _networkService,
      ),
    );

    WalletInjector.instance.registerLazySingleton(
      () => PayWithAliasUseCase(
        getIt<SaleByWalletRepository>(),
      ),
    );

    WalletInjector.instance.registerLazySingleton(
      () => PayWithMobileNumberUseCase(
        getIt<SaleByWalletRepository>(),
      ),
    );

    WalletInjector.instance.registerLazySingleton(
      () => VerifyCustomerUseCase(
        getIt<SaleByWalletRepository>(),
      ),
    );

    WalletInjector.instance.registerLazySingleton<SaleByWalletPayCubit>(
      () => SaleByWalletPayCubit(
        getIt<PayWithAliasUseCase>(),
        getIt<PayWithMobileNumberUseCase>(),
      ),
    );

    WalletInjector.instance.registerLazySingleton<SaleByWalletVerifyCubit>(
      () => SaleByWalletVerifyCubit(
        getIt<VerifyCustomerUseCase>(),
      ),
    );

    WalletInjector.instance.registerLazySingleton<SaleByWalletCubit>(
      () => SaleByWalletCubit(),
    );

    WalletInjector.instance
        .registerLazySingleton<IUseCase<QRResponse, WalletPaymentRequest>>(
      () => PayWithQrUseCase(
        getIt<SaleByWalletRepository>(),
      ),
    );

    WalletInjector.instance.registerLazySingleton(
      () => SaleByQrCubit(
        getIt<IUseCase<QRResponse, WalletPaymentRequest>>(),
      ),
    );
  }

  // static const saleByWalletView = '/sale_by_wallet_route/';
  // static const saleByWalletPayingOptionsView =
  //     '/sale_by_wallet_route/sale_by_wallet_paying_options/';
}
