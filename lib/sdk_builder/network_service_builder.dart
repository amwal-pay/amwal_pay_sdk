import 'package:amwal_pay_sdk/core/networking/dio_client.dart';
import 'package:amwal_pay_sdk/core/networking/mockup_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/core/networking/secure_hash_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/token_interceptor.dart';

class NetworkServiceBuilder {
  const NetworkServiceBuilder._();
  static NetworkServiceBuilder get instance => const NetworkServiceBuilder._();
  DioClient _initDioClientWithInterceptors(
    bool isMocked,
    String secureHashValue,
    String requestSourceId,
    String apiKey,
  ) {
    final tokenInterceptor = TokenInjectorInterceptor(apiKey);
    final mockupInterceptor = MockupInterceptor(isMocked);
    final secureHashInterceptor = SecureHashInterceptor(
      secureHashValue: secureHashValue,
      requestSourceId: requestSourceId,
    );
    return DioClient(
      mockupInterceptor,
      secureHashInterceptor,
      tokenInterceptor,
    );
  }

  NetworkService setupNetworkService(
    bool isMocked,
    String secureHashValue,
    String requestSourceId,
    String apiKey,
  ) =>
      NetworkService(_initDioClientWithInterceptors(
        isMocked,
        secureHashValue,
        requestSourceId,
        apiKey,
      ));
}
