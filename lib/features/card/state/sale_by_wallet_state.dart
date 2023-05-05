import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_by_wallet_state.freezed.dart';

@freezed
class SaleByWalletState with _$SaleByWalletState {
  const factory SaleByWalletState.initial(
    int page, {
    @Default(false) bool verified,
  }) = _Initial;
  const factory SaleByWalletState.verified(
    int page, {
    @Default(true) bool verified,
  }) = _Verified;
}
