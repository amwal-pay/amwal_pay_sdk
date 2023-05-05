import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class VerifyCustomerResponse extends BaseResponse<String?> {
  VerifyCustomerResponse({
    required super.success,
    super.responseCode,
    super.message,
    super.data,
  });

  factory VerifyCustomerResponse.fromJson(dynamic json) {
    return VerifyCustomerResponse(
      success: json['success'],
      responseCode: int.tryParse(json['responseCode']),
      message: json['message'],
      data: json['data'],
    );
  }
}
