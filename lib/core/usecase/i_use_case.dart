import 'package:amwal_pay_sdk/core/networking/network_state.dart';

abstract class IUseCase<T, R> {
  const IUseCase();
  Future<NetworkState<T>> invoke(R param);
}
