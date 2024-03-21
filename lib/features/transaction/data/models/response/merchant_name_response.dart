import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class MerchantNameResponse extends BaseResponse<String?> {
  MerchantNameResponse({
    required super.success,
    super.data,
    super.message,
  });

  factory MerchantNameResponse.fromJson(dynamic json) {
    return MerchantNameResponse(
      success: json['success'],
      message: json['message'],
      data:json['data'].toString(),
    );
  }
}
