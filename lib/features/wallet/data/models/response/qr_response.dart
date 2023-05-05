import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class QRResponse extends BaseResponse<QRData> {
  QRResponse({
    required super.success,
    super.responseCode,
    super.message,
    super.data,
  });

  factory QRResponse.fromJson(dynamic json) {
    return QRResponse(
      success: json['success'],
      responseCode: int.tryParse(json['responseCode']),
      message: json['message'],
      data: QRData.fromMap(json['data']),
    );
  }
}

class QRData {
  final String qrCode;
  const QRData({
    required this.qrCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QRData &&
          runtimeType == other.runtimeType &&
          qrCode == other.qrCode);

  @override
  int get hashCode => qrCode.hashCode;

  QRData copyWith({
    String? qrCode,
  }) {
    return QRData(
      qrCode: qrCode ?? this.qrCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'qrCode': qrCode,
    };
  }

  factory QRData.fromMap(Map<String, dynamic> map) {
    return QRData(
      qrCode: map['qrCode'] as String,
    );
  }
}
