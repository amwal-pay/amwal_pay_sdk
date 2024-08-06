import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class PurchaseResponse extends BaseResponse<PurchaseData> {
  PurchaseResponse({
    required super.success,
    super.message,
    super.data,
  });

  factory PurchaseResponse.fromJson(dynamic json) {
    return PurchaseResponse(
      success: json['success'],
      message: json['message'],
      data: PurchaseData.fromMap(
        json['data'],
      ),
    );
  }
}

class PurchaseData {
  final String message;
  final String transactionId;


  final int terminalId;
  final bool isOtpRequired;
  final HostResponseData hostResponseData;

//<editor-fold desc="Data Methods">
    PurchaseData({
    required this.terminalId,
    required this.message,
    required this.transactionId,
    required this.hostResponseData,
    required this.isOtpRequired,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseData &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          transactionId == other.transactionId &&
          hostResponseData == other.hostResponseData);

  @override
  int get hashCode =>
      message.hashCode ^ transactionId.hashCode ^ hostResponseData.hashCode;

  PurchaseData copyWith({
    String? transactionNo,
    String? approvalCode,
    String? actionCode,
    String? message,
    String? authCode,
    String? transactionId,
    bool? signatureRequired,
    String? mwActionCode,
    String? mwMessage,
    String? threeDSecureUrl,
    HostResponseData? hostResponseData,
    int? terminalId,
  }) {
    return PurchaseData(
      terminalId: terminalId ?? this.terminalId,
      message: message ?? this.message,
      transactionId: transactionId ?? this.transactionId,
      hostResponseData: hostResponseData ?? this.hostResponseData,
      isOtpRequired: isOtpRequired,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'terminalId': terminalId,
      'message': message,
      'transactionId': transactionId,
      'hostResponseData': hostResponseData.toMap(),
      'isOtpRequired': isOtpRequired,
    };
  }

  factory PurchaseData.fromMap(Map<String, dynamic> map) {
    return PurchaseData(
      terminalId: map['terminalId'],
      message: map['message'] as String,
      transactionId: map['transactionId'] as String,
      hostResponseData: HostResponseData.fromMap(map['hostResponseData']),
      isOtpRequired: map['isOtpRequired'],
    );
  }

//</editor-fold>
}

class HostResponseData {
  final String? transactionId;
  final String? rrn;
  final String? stan;
  final String? trackId;
  final String? paymentId;
  final String? accessUrl;

//<editor-fold desc="Data Methods">
  const HostResponseData({
    required this.transactionId,
    required this.rrn,
    required this.stan,
    required this.trackId,
    required this.paymentId,
    required this.accessUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HostResponseData &&
          runtimeType == other.runtimeType &&
          transactionId == other.transactionId &&
          rrn == other.rrn &&
          stan == other.stan &&
          trackId == other.trackId &&
          paymentId == other.paymentId);

  @override
  int get hashCode =>
      transactionId.hashCode ^
      rrn.hashCode ^
      stan.hashCode ^
      trackId.hashCode ^
      paymentId.hashCode;

  HostResponseData copyWith({
    String? transactionId,
    String? rrn,
    String? stan,
    String? trackId,
    String? paymentId,
    String? accessUrl,
  }) {
    return HostResponseData(
      transactionId: transactionId ?? this.transactionId,
      rrn: rrn ?? this.rrn,
      stan: stan ?? this.stan,
      trackId: trackId ?? this.trackId,
      paymentId: paymentId ?? this.paymentId,
      accessUrl: accessUrl ?? this.accessUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TransactionId': transactionId,
      'Rrn': rrn,
      'Stan': stan,
      'TrackId': trackId,
      'PaymentId': paymentId,
      'AccessUrl': accessUrl,
    };
  }

  factory HostResponseData.fromMap(Map<String, dynamic> map) {
    return HostResponseData(
      transactionId: map['TransactionId'] as String?,
      rrn: map['Rrn'] as String?,
      stan: map['Stan'] as String?,
      trackId: map['TrackId'] as String?,
      paymentId: map['PaymentId'] as String?,
      accessUrl: map['AccessUrl'] as String?,
    );
  }
}
