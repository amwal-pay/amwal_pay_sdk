import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_manual_cubit.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/CardInfo.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:debit_credit_card_widget/debit_credit_card_widget.dart';
import 'package:flutter/services.dart';

import '../../../core/apiview/state_mapper.dart';

const MethodChannel javaChannel = MethodChannel('com_amwalpay_sdk');

class SaleByCardContactLessCubit extends SaleByCardManualCubit {
  int setupStatusIndex = 0;
  String setupMessage = "Initializing SDK..";
  CardInfo? cardInfo;
  PaymentArguments? arg;

  SaleByCardContactLessCubit(super.purchaseUseCase,
      super.purchaseOtpStepOneUseCase, super.purchaseOtpStepTwoUseCase);

  CardBrand getCardBrand(String cardNumber) {
    if (cardNumber.isEmpty) {
      return CardBrand.visa;
    }

    cardNumber = cardNumber.replaceAll(RegExp(r'\s+'), ''); // Remove any spaces

    // Define card brand patterns
    final cardBrandPatterns = {
      "Visa": RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$'),
      "MasterCard": RegExp(
          r'^(?:5[1-5][0-9]{14}|2(?:2[2-9][0-9]{12}|[3-6][0-9]{13}|7[01][0-9]{12}|720[0-9]{12}))$'),
      "American Express": RegExp(r'^3[47][0-9]{13}$'),
      "Discover": RegExp(r'^6(?:011|5[0-9]{2})[0-9]{12}$'),
      "JCB": RegExp(r'^(?:2131|1800|35\d{3})\d{11}$'),
      "Diners Club": RegExp(r'^3(?:0[0-5]|[68][0-9])[0-9]{11}$'),
      "Maestro":
          RegExp(r'^(5018|5020|5038|5893|6304|6759|676[1-3])[0-9]{8,15}$'),
      "UnionPay": RegExp(r'^(62[0-9]{14,17})$'),
      "RuPay": RegExp(r'^(60|65|81|82|508)[0-9]{14,15}$'),
    };

    // Check card number against patterns
    for (var entry in cardBrandPatterns.entries) {
      if (entry.value.hasMatch(cardNumber)) {
        if (entry.key == "Visa") {
          return CardBrand.visa;
        } else if (entry.key == "MasterCard") {
          return CardBrand.mastercard;
        } else if (entry.key == "American Express") {
          return CardBrand.americanExpress;
        } else if (entry.key == "Discover") {
          return CardBrand.discover;
        } else if (entry.key == "RuPay") {
          return CardBrand.rupay;
        }
        return CardBrand.visa;
      }
    }

    return CardBrand.visa;
  }

  void fillCardData(CardInfo cardInfo) {
    cardNo = cardInfo.cardNumber;
    cardHolderName =
        ("${cardInfo.holderFirstname ?? ""} ${cardInfo.holderLastname ?? ""}");
    expirationDateMonth = cardInfo.cardExpiry?.split("/")[0];
    expirationDateYear = cardInfo.cardExpiry?.split("/")[1];

    emit(ICubitState.success(uiModel: PurchaseResponse(success: true)));
  }
}
