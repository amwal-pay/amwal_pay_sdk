import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/features/card/amwal_salebycard_sdk.dart';
import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_manual_cubit.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/CardInfo.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/card/transaction_manager/amwal_card_transaction_manager.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/use_case/get_transaction_by_Id.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:amwal_pay_sdk/service/nfc_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:debit_credit_card_widget/debit_credit_card_widget.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

class SaleByCardContactLessCubit extends SaleByCardManualCubit {
  int setupStatusIndex = 0;
  String setupMessage = "Initializing SDK..";
  CardInfo? cardInfo;
  PaymentArguments? arg;
  NFCStatus? nfcStatus;

  SaleByCardContactLessCubit(
    super.purchaseUseCase,
    super.purchaseOtpStepOneUseCase,
    super.purchaseOtpStepTwoUseCase,
    super.payWithTokenUseCase,
    super.getCustomerTokensUseCase,
  );

  Future<NFCStatus> checkNFCStatus(
    BuildContext context,
    dynamic globalTranslator,
  ) async {
    try {
      nfcStatus = await NFCManager.instance.initNFC();
      if (nfcStatus == NFCStatus.enabled) {
        setupMessage = "start_scan".translate(
          context.mounted ? context : context,
          globalTranslator: globalTranslator,
        );
      } else if (nfcStatus == NFCStatus.notAvailable) {
        setupMessage = "nfc_unavailable".translate(
          context.mounted ? context : context,
          globalTranslator: globalTranslator,
        );
      } else {
        setupMessage = "nfc_unavailable_massage".translate(
          context.mounted ? context : context,
          globalTranslator: globalTranslator,
        );
      }
      return nfcStatus!;
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      nfcStatus = NFCStatus.notAvailable;
      setupMessage = "nfc_unavailable".translate(
        context.mounted ? context : context,
        globalTranslator: globalTranslator,
      );
      return nfcStatus!;
    }
  }

  Future<Either<String, Unit>> startNFCScan(
    BuildContext context,
    dynamic translator,
    void Function(BuildContext) dismissDialog,
    OnPayCallback? onPay,
    EventCallback? log,
  ) async {
    final scanResult = await NFCManager.instance.startNFCScan();
    if (!scanResult['success']) {
      await terminateNFC();
      if (context.mounted) {
        startNFCScan(
          context,
          translator,
          dismissDialog,
          onPay,
          log,
        );
        terminateNFC();
      }
      FirebaseCrashlytics.instance.recordError(scanResult['error'], null);
      return left(scanResult['error']);
    } else {
      if (cardInfo == null) {
        await terminateNFC();
        FirebaseCrashlytics.instance.log(scanResult.toString());
        try {
          scanResult['cardExpiry'] = _convertArabicToEnglishNumbers(
            scanResult['cardExpiry'] ?? '',
          );
        } catch (e) {
          FirebaseCrashlytics.instance.recordError(scanResult, null);
        }

        cardInfo = CardInfo.fromJson(scanResult);
        fillCardData(cardInfo!);

        AmwalCardTransactionManager(
          context: context.mounted ? context : context,
          paymentArguments: arg!,
          saleByCardManualCubit: this,
          onPay: onPay,
          log: log,
          getOneTransactionByIdUseCase:
              CardInjector.instance.get<GetOneTransactionByIdUseCase>(),
        ).onPurchaseWith3DS(
          dismissLoader: dismissDialog,
        );

        setupMessage = "Scanning completed".translate(
          context.mounted ? context : context,
          globalTranslator: translator,
        );
      }
      return right(unit);
    }
  }

  Future<void> terminateNFC() async {
    await NFCManager.instance.terminateNFC();
  }

  void onDispose() async {
    cardInfo = null;
    nfcStatus = null;
    setupMessage = "Checking NFC...";
    arg = null;
    await terminateNFC();
  }

  String _convertArabicToEnglishNumbers(String arabicDate) {
    const arabicToEnglishMap = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };

    StringBuffer englishDate = StringBuffer();

    for (int i = 0; i < arabicDate.length; i++) {
      String character = arabicDate[i];
      englishDate.write(arabicToEnglishMap[character] ?? character);
    }

    return englishDate.toString();
  }

  CardBrand getCardBrand(String cardNumber) {
    if (cardNumber.isEmpty) {
      return CardBrand.visa;
    }

    cardNumber = cardNumber.replaceAll(RegExp(r'\s+'), ''); // Remove any spaces

    // Define card brand patterns
    final cardBrandPatterns = {
      "Visa": RegExp(
        r'^4[0-9]{12}(?:[0-9]{3})?$',
      ),
      "MasterCard": RegExp(
        r'^(?:5[1-5][0-9]{14}|2(?:2[2-9][0-9]{12}|[3-6][0-9]{13}|7[01][0-9]{12}|720[0-9]{12}))$',
      ),
      "American Express": RegExp(
        r'^3[47][0-9]{13}$',
      ),
      "Discover": RegExp(
        r'^6(?:011|5[0-9]{2})[0-9]{12}$',
      ),
      "JCB": RegExp(
        r'^(?:2131|1800|35\d{3})\d{11}$',
      ),
      "Diners Club": RegExp(
        r'^3(?:0[0-5]|[68][0-9])[0-9]{11}$',
      ),
      "Maestro": RegExp(
        r'^(5018|5020|5038|5893|6304|6759|676[1-3])[0-9]{8,15}$',
      ),
      "UnionPay": RegExp(
        r'^(62[0-9]{14,17})$',
      ),
      "RuPay": RegExp(
        r'^(60|65|81|82|508)[0-9]{14,15}$',
      ),
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
    cvV2 = "";
    emit(ICubitState.success(uiModel: PurchaseResponse(success: true)));
  }
}
