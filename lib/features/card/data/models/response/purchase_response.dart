import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class PurchaseResponse extends BaseResponse<PurchaseData> {
  PurchaseResponse({
    required super.success,
    super.responseCode,
    super.message,
    super.data,
  });

  factory PurchaseResponse.fromJson(dynamic json) {
    return PurchaseResponse(
      success: json['success'],
      responseCode: int.tryParse(json['responseCode']),
      message: json['message'],
      data: PurchaseData.fromMap(
        json['data'],
      ),
    );
  }
}

class PurchaseData {
  final String txnResponseCode;
  final String transactionNo;
  final String systemTraceNr;
  final String approvalCode;
  final String actionCode;
  final String message;
  final String authCode;
  final String transactionId;
  final bool? signatureRequired;
  final String? mwActionCode;
  final String? mwMessage;
  final HostResponseData hostResponseData;

//<editor-fold desc="Data Methods">
  const PurchaseData({
    required this.txnResponseCode,
    required this.transactionNo,
    required this.systemTraceNr,
    required this.approvalCode,
    required this.actionCode,
    required this.message,
    required this.authCode,
    required this.transactionId,
    this.signatureRequired,
    this.mwActionCode,
    this.mwMessage,
    required this.hostResponseData,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseData &&
          runtimeType == other.runtimeType &&
          txnResponseCode == other.txnResponseCode &&
          transactionNo == other.transactionNo &&
          systemTraceNr == other.systemTraceNr &&
          approvalCode == other.approvalCode &&
          actionCode == other.actionCode &&
          message == other.message &&
          authCode == other.authCode &&
          transactionId == other.transactionId &&
          signatureRequired == other.signatureRequired &&
          mwActionCode == other.mwActionCode &&
          mwMessage == other.mwMessage &&
          hostResponseData == other.hostResponseData);

  @override
  int get hashCode =>
      txnResponseCode.hashCode ^
      transactionNo.hashCode ^
      systemTraceNr.hashCode ^
      approvalCode.hashCode ^
      actionCode.hashCode ^
      message.hashCode ^
      authCode.hashCode ^
      transactionId.hashCode ^
      signatureRequired.hashCode ^
      mwActionCode.hashCode ^
      mwMessage.hashCode ^
      hostResponseData.hashCode;

  PurchaseData copyWith({
    String? txnResponseCode,
    String? transactionNo,
    String? systemTraceNr,
    String? approvalCode,
    String? actionCode,
    String? message,
    String? authCode,
    String? transactionId,
    bool? signatureRequired,
    String? mwActionCode,
    String? mwMessage,
    HostResponseData? hostResponseData,
  }) {
    return PurchaseData(
      txnResponseCode: txnResponseCode ?? this.txnResponseCode,
      transactionNo: transactionNo ?? this.transactionNo,
      systemTraceNr: systemTraceNr ?? this.systemTraceNr,
      approvalCode: approvalCode ?? this.approvalCode,
      actionCode: actionCode ?? this.actionCode,
      message: message ?? this.message,
      authCode: authCode ?? this.authCode,
      transactionId: transactionId ?? this.transactionId,
      signatureRequired: signatureRequired ?? this.signatureRequired,
      mwActionCode: mwActionCode ?? this.mwActionCode,
      mwMessage: mwMessage ?? this.mwMessage,
      hostResponseData: hostResponseData ?? this.hostResponseData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'txnResponseCode': txnResponseCode,
      'transactionNo': transactionNo,
      'systemTraceNr': systemTraceNr,
      'approvalCode': approvalCode,
      'actionCode': actionCode,
      'message': message,
      'authCode': authCode,
      'transactionId': transactionId,
      'signatureRequired': signatureRequired,
      'mwActionCode': mwActionCode,
      'mwMessage': mwMessage,
      'hostResponseData': hostResponseData.toMap(),
    };
  }

  factory PurchaseData.fromMap(Map<String, dynamic> map) {
    return PurchaseData(
      txnResponseCode: map['txnResponseCode'] as String,
      transactionNo: map['transactionNo'] as String,
      systemTraceNr: map['systemTraceNr'] as String,
      approvalCode: map['approvalCode'] as String,
      actionCode: map['actionCode'] as String,
      message: map['message'] as String,
      authCode: map['authCode'] as String,
      transactionId: map['transactionId'] as String,
      signatureRequired: map['signatureRequired'] as bool?,
      mwActionCode: map['mwActionCode'] as String?,
      mwMessage: map['mwMessage'] as String?,
      hostResponseData: HostResponseData.fromMap(map['hostResponseData']),
    );
  }

//</editor-fold>
}

class HostResponseData {
  final String transactionId;
  final String rrn;
  final String stan;
  final String trackId;
  final String paymentId;

//<editor-fold desc="Data Methods">
  const HostResponseData({
    required this.transactionId,
    required this.rrn,
    required this.stan,
    required this.trackId,
    required this.paymentId,
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
  }) {
    return HostResponseData(
      transactionId: transactionId ?? this.transactionId,
      rrn: rrn ?? this.rrn,
      stan: stan ?? this.stan,
      trackId: trackId ?? this.trackId,
      paymentId: paymentId ?? this.paymentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TransactionId': transactionId,
      'Rrn': rrn,
      'Stan': stan,
      'TrackId': trackId,
      'PaymentId': paymentId,
    };
  }

  factory HostResponseData.fromMap(Map<String, dynamic> map) {
    return HostResponseData(
      transactionId: map['TransactionId'] as String,
      rrn: map['Rrn'] as String,
      stan: map['Stan'] as String,
      trackId: map['TrackId'] as String,
      paymentId: map['PaymentId'] as String,
    );
  }
}
