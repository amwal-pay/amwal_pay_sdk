import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class CurrenciesResponse extends BaseResponse<List<CurrencyData>> {
  CurrenciesResponse({
    required super.success,
    super.responseCode,
    super.message,
    super.data,
  });

  factory CurrenciesResponse.fromJson(dynamic json) {
    return CurrenciesResponse(
      success: json['success'],
      message: json['message'],
      responseCode: json['responseCode'],
      data: (json['data'] as List).map(CurrencyData.fromJson).toList(),
    );
  }
}

class CurrencyData {
  final int idN;
  final String id;
  final String name;

  const CurrencyData({
    required this.idN,
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'idN': idN,
        'id': id,
        'name': name,
      };

  factory CurrencyData.fromJson(dynamic json) {
    return CurrencyData(
      idN: json['idN'],
      id: json['id'],
      name: json['name'],
    );
  }
}
