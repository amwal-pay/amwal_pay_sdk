
# Amwal Pay SDK

Amwal Pay SDK built in Flutter makes online payment easier.

## Features
- **Payment With Wallet**
  - With mobile number
  - With alias name
  - With QRCode
  - With NFC
- **Payment With Card**

 
![alt text](https://github.com/amwal-pay/amwal_pay_sdk/blob/main/screen_shot/example.jpeg?raw=true)
![alt text](https://github.com/amwal-pay/amwal_pay_sdk/blob/main/screen_shot/view.jpeg?raw=true)

 

## Usage

1. **Add the package as a dependency** in your `pubspec.yaml` file:

```yaml
dependencies:
  amwal_pay_sdk:
    git:
     url: https://github.com/amwal-pay/amwal_pay_sdk
     ref: main
```

2. **Import the package** in your Dart file where you want to use it by adding the following line at the top of the file:

```dart
import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
```

3. **Fetching the Customer ID and Session Token:**

To initialize the payment, you need to fetch the `customerId` first. Then, pass the `merchantId`, and `customerId` to the backend to retrieve the session token. This session token is then used to initialize the payment.

Here’s how it works:

```dart
final customerId = await _getCustomerId(); // Fetch the session token from the backend

final sessionToken = await getSDKSessionToken( // Fetch the session token from the backend
  merchantId: _merchantId,
  customerId: customerId,
);

if (sessionToken == null) return;

// this will route to SDK
await AmwalPaySdk.instance.initSdk(
  settings: AmwalSdkSettings(
    sessionToken: sessionToken ?? '', // Use the session token here
    currency: _currencyController.text, // OMR
    amount: _amountController.text, //100
    transactionId: const Uuid().v1(), // Unique transaction ID
    merchantId: _merchantIdController.text, // Your merchant ID
    terminalId: _terminalController.text, // Your terminal ID
    locale: Locale(_languageController.text), // Locale for the payment // ex en, ar
    customerCallback: _onCustomerId, // Callback for customer id after finish the payment
    customerId: customerId, // The customer ID for this transaction
    onResponse: _onResponse, // Callback for the payment response
  ),
);
```

 

## Example

You can see a full example of how to use the package in the [Example] example directory.

## Issues

If you encounter any issues while using the package, please file a bug report in [the Github issue tracker].

## Contributing

If you would like to contribute to the package, please read the [Contributing Guidelines] before submitting a pull request.

## AmwalSdkSettings Parameters

| Parameter         | Description                                             |
| ----------------- |---------------------------------------------------------|
| `sessionToken`    | The session token obtained from your backend            |
| `currency`        | Name of the currency that the client will pay with      |
| `amount`          | The amount of payment                                   |
| `merchantId`      | Your Merchant Id                                        |
| `terminalId`      | Your terminalId                                         |
| `customerId`      | The customer ID used to authenticate the payment        |
| `transactionId`   | Unique identifier for the transaction                   |
| `locale`          | The locale for the payment process (e.g., "en" or "ar") |
| `customerCallback`| The callback function for customer id after finish      |
| `onResponse`      | The callback function to handle the payment response    |

---

**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

[Example]: <https://github.com/amwal-pay/amwal_pay_sdk/-/tree/master/example>
[the Github issue tracker]: <https://github.com/amwal-pay/amwal_pay_sdk/-/issues>
[Contributing Guidelines]: <https://github.com/amwal-pay/amwal_pay_sdk/-/blob/master/CHANGELOG.md>
