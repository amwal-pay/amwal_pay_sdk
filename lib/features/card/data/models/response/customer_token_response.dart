import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class CustomerTokenResponse extends BaseResponse<List<CustomerToken>> {
  CustomerTokenResponse({
    required super.success,
    super.message,
    super.data,
  });

  factory CustomerTokenResponse.fromJson(dynamic json) {
    return CustomerTokenResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data']['cardList'] as List)
          .map(CustomerToken.fromMap)
          .toList(),
    );
  }
}

class CustomerToken {
  final String cardNumber;
  final String customerTokenId;

  CustomerToken({required this.cardNumber, required this.customerTokenId});

  factory CustomerToken.fromMap(dynamic json) => CustomerToken(
      cardNumber: json['cardNumber'], customerTokenId: json['customerTokenId']);
}
