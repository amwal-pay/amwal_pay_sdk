import 'package:amwal_pay_sdk/core/base_response/base_response.dart';
import 'package:intl/intl.dart';

import '../../../../../amwal_sdk_settings/amwal_sdk_setting_container.dart';

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
  final String? transactionTypeId;
  final String? transactionTypeDisplayName;
  final String? merchantId;
  final String? currency;
  final String? amount;
  final String? currencyId;
  final String? transactionDate;
  final String? merchantName;
  final bool isOtpRequired;
  final String? customerId;
  final String? gatewayTransactionReference;
  final String? customerTokenId;
  final HostResponseData hostResponseData;

//<editor-fold desc="Data Methods">
  PurchaseData({
    required this.terminalId,
    required this.message,
    required this.transactionId,
    required this.hostResponseData,
    required this.isOtpRequired,
    this.customerId,
    this.customerTokenId,
    this.transactionTypeId,
    this.transactionTypeDisplayName,
    this.merchantId,
    this.currency,
    this.amount,
    this.currencyId,
    this.merchantName,
    this.gatewayTransactionReference,
    this.transactionDate,
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
    String? transactionDate,
    String? gatewayTransactionReference,
    String? merchantName,
  }) {
    return PurchaseData(
      terminalId: terminalId ?? this.terminalId,
      message: message ?? this.message,
      transactionId: transactionId ?? this.transactionId,
      hostResponseData: hostResponseData ?? this.hostResponseData,
      isOtpRequired: isOtpRequired,
      transactionTypeId: transactionTypeId,
      transactionTypeDisplayName: transactionTypeDisplayName,
      merchantId: merchantId,
      currency: currency,
      amount: amount,
      currencyId: currencyId,
      customerId: customerId,
      customerTokenId: customerTokenId,
      gatewayTransactionReference: gatewayTransactionReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'terminalId': terminalId,
      'message': message,
      'transactionId': transactionId,
      'gatewayTransactionReference': gatewayTransactionReference,
      'hostResponseData': hostResponseData.toMap(),
      'isOtpRequired': isOtpRequired,
    };
  }

  factory PurchaseData.fromMap(Map<String, dynamic> map) {
    return PurchaseData(
        message: map['message'] as String,
        transactionId: map['transactionId'] as String,
        hostResponseData: HostResponseData.fromMap(map['hostResponseData']),
        isOtpRequired: map['isOtpRequired'],
        terminalId: map['terminalId'],
        transactionTypeId: map['transactionTypeId']?.toString(),
        transactionTypeDisplayName:
            map['transactionTypeDisplayName']?.toString(),
        currency: map['currency']?.toString(),
        currencyId: map['currencyId']?.toString(),
        merchantId: map['merchantId']?.toString(),
        amount: map['amount']?.toString(),
        transactionDate: formatLastLoggedInDate(
            map['transactionDate'] ?? map['transactionTime']),
        merchantName: map['merchantName'],
        customerTokenId: map['customerTokenId'],
        gatewayTransactionReference: map['gatewayTransactionReference'],
        customerId: map['customerId']);
  }

  static String formatLastLoggedInDate(String? value) {
    try {
      if (value == null) return '';
      final date = DateTime.parse(value);
      return DateFormat.yMMMMEEEEd(AmwalSdkSettingContainer.locale)
          .add_jm()
          .format(date);
    } catch (e) {
      return value ?? "";
    }
  }

  factory PurchaseData.fromUri(Uri uri) {
    return PurchaseData(
      message: uri.queryParameters.containsKey('isSuccess')
          ? ((uri.queryParameters['isSuccess'].toString()) == "true" ? "success":"canceled" )?? ""
          : "",
      transactionId: uri.queryParameters.containsKey('transactionId')
          ? uri.queryParameters['transactionId'] ?? ""
          : "",
      gatewayTransactionReference:
          uri.queryParameters.containsKey('gatewayTransactionReference')
              ? uri.queryParameters['gatewayTransactionReference'] ?? ""
              : "",
      terminalId: int.parse(uri.queryParameters.containsKey('terminalId')
          ? uri.queryParameters['terminalId'] ?? '0'
          : '0'),
      hostResponseData: HostResponseData(
        transactionId: uri.queryParameters.containsKey('transactionId')
            ? uri.queryParameters['transactionId'] ?? ""
            : "",
        rrn: uri.queryParameters.containsKey('Rrn')
            ? uri.queryParameters['Rrn'] ?? ""
            : "",
        stan: '',
        trackId: uri.queryParameters.containsKey('TrackId')
            ? uri.queryParameters['TrackId'] ?? ""
            : "",
        paymentId: uri.queryParameters.containsKey('PaymentId')
            ? uri.queryParameters['PaymentId'] ?? ""
            : "",
        accessUrl: uri.queryParameters.containsKey('AccessUrl')
            ? uri.queryParameters['AccessUrl'] ?? ""
            : "",
      ),
      isOtpRequired: false,
      merchantName: uri.queryParameters.containsKey('merchantName')
          ? uri.queryParameters['merchantName'] ?? ""
          : '',
      merchantId: uri.queryParameters.containsKey('merchantId')
          ? uri.queryParameters['merchantId'] ?? ""
          : '',
      currency: uri.queryParameters.containsKey('currency')
          ? uri.queryParameters['currency'] ?? ""
          : '',
      currencyId: uri.queryParameters.containsKey('currencyId')
          ? uri.queryParameters['currencyId'] ?? ""
          : '',
      transactionDate: formatLastLoggedInDate(
          uri.queryParameters.containsKey('transactionTime')
              ? uri.queryParameters['transactionTime'] ?? ""
              : ''),
      amount: uri.queryParameters.containsKey('amount')
          ? uri.queryParameters['amount'] ?? ""
          : '',
      customerTokenId: uri.queryParameters.containsKey('customerTokenId')
          ? uri.queryParameters['customerTokenId'] ?? ""
          : '',
      customerId: uri.queryParameters.containsKey('customerId')
          ? uri.queryParameters['customerId'] ?? ""
          : '',
      transactionTypeDisplayName:
          uri.queryParameters.containsKey('transactionTypeDisplayName')
              ? uri.queryParameters['transactionTypeDisplayName'] ?? ""
              : '',
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
