import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class VerifyCustomerResponse extends BaseResponse<VerifyCustomerResponseData?> {
  VerifyCustomerResponse({
    required super.success,
    super.message,
    super.data,
  });

  factory VerifyCustomerResponse.fromJson(dynamic json) {
    return VerifyCustomerResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? VerifyCustomerResponseData.fromJson(json['data'])
          : null);
  }
}


/// customerName : "ABD#####@ampy"
/// customerType : "PER"

class VerifyCustomerResponseData {
  VerifyCustomerResponseData({
    String? customerName,
    String? customerType,}){
    _customerName = customerName;
    _customerType = customerType;
  }

  VerifyCustomerResponseData.fromJson(dynamic json) {
    _customerName = json['customerName'];
    _customerType = json['customerType'];
  }
  String? _customerName;
  String? _customerType;
  VerifyCustomerResponseData copyWith({  String? customerName,
    String? customerType,
  }) => VerifyCustomerResponseData(  customerName: customerName ?? _customerName,
    customerType: customerType ?? _customerType,
  );
  String? get customerName => _customerName;
  String? get customerType => _customerType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['customerName'] = _customerName;
    map['customerType'] = _customerType;
    return map;
  }

}