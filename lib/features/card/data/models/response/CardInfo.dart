import 'dart:convert';

class CardInfo {
  final bool success;
  final String? cardData;
  final String? cardNumber;
  final String? cardExpiry;
  final String? holderFirstname;
  final String? holderLastname;

  CardInfo({
    required this.success,
    required this.cardData,
    required this.cardNumber,
    required this.cardExpiry,
    required this.holderFirstname,
    required this.holderLastname,
  });

  // A factory constructor to create an instance of CardInfo from a JSON object
  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      success: json['success'],
      cardData: json['cardData'],
      cardNumber: json['cardNumber'],
      cardExpiry: json['cardExpiry'],
      holderFirstname: json['holderFirstname'],
      holderLastname: json['holderLastname'],
    );
  }

  // A method to convert an instance of CardInfo to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'cardData': cardData,
      'cardNumber': cardNumber,
      'cardExpiry': cardExpiry,
      'holderFirstname': holderFirstname,
      'holderLastname': holderLastname,
    };
  }
}


