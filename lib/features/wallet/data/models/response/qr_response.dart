import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class QRResponse extends BaseResponse<String?> {
  QRResponse({
    required super.success,
    super.responseCode,
    super.message,
    super.data,
  });

  factory QRResponse.fromJson(dynamic json) {
    return QRResponse(
      success: json['success'],
      responseCode:json['responseCode']!=null? int.tryParse(json['responseCode']):null,
      message: json['message'],
      data: json['data'],
    );
  }
}

