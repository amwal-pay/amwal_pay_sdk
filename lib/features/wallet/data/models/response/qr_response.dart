import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class QRResponse extends BaseResponse<QrData> {
  QRResponse({
    required super.success,
    super.message,
    super.data,
  });

  factory QRResponse.fromJson(dynamic json) {
    return QRResponse(
      success: json['success'],
      message: json['message'],
      data: QrData.fromJson(json['data']),
    );
  }
}

class QrData {
  final String qrCode;
  final int? idN;
  final String? walletOrderId;

  const QrData({
    required this.qrCode,
    this.idN,
    this.walletOrderId,
  });

  factory QrData.fromJson(dynamic json) {
    return QrData(
      qrCode: json['qrCode'],
      idN: json['idN'],
      walletOrderId: json['walletOrderId'],
    );
  }
}
