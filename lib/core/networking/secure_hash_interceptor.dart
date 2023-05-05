import 'package:amwal_pay_sdk/core/merchant_store/merchant_store.dart';
import 'package:dio/dio.dart';

class SecureHashInterceptor extends Interceptor {
  final String secureHashValue;
  final String requestSourceId;

  SecureHashInterceptor({
    required this.secureHashValue,
    required this.requestSourceId,
  });

  Map<String, dynamic> _voidHandleTerminalId(RequestOptions options) {
    final data = options.data as Map<String, dynamic>;
    // if (!isMerchantIdIncluded(options)) {
    //   return data;
    // }
    // // if (merchant != null && merchant!.terminals.length == 1) {
    //   final terminalId = merchant!.terminals.single.terminalId;
    //   if (data.containsKey('terminalId')) {
    //     data['terminalId'] = terminalId;
    //   } else {
    //     data.addAll({'terminalId': terminalId});
    //   }
    // }
    return data;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final data = _voidHandleTerminalId(options);
    final terminals = MerchantStore.instance.getTerminal();
    if (terminals.length == 1) {
      data.addAll({
        'terminalId': terminals.single,
      });
    }
    data.addAll({
      'requestSourceId': requestSourceId,
      'secureHashValue': secureHashValue,
    });
    final interceptedOptions = options.copyWith(data: data);
    super.onRequest(interceptedOptions, handler);
  }
}
