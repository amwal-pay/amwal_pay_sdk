class DigitalWalletResponse {
  final String? message;
  final String? status;

  DigitalWalletResponse({
    this.message,
    this.status,
  });

  factory DigitalWalletResponse.fromJson(Map<String, dynamic> json) {
    return DigitalWalletResponse(
      message: json['message'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
    };
  }
}
