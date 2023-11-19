class TransactionOperationResponse {
  final bool isSuccess;
  final String? message;
  final List<String>? errorList;
  final String? transactionId;

  TransactionOperationResponse({
    required this.isSuccess,
    this.transactionId,
    this.message,
    this.errorList,
  });
}
