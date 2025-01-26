# Amwal Pay SDK

The **Amwal Pay SDK** is a Flutter-based SDK designed to simplify online payments. It supports multiple payment methods, including wallet-based payments (via mobile number, alias, QR code, or NFC) and card payments. This SDK is highly customizable and easy to integrate into your Flutter applications.

---

## Features

- **Payment With Wallet**
  - With mobile number
  - With alias name
  - With QRCode
  - With NFC
- **Payment With Card**
- **Environment Support**
  - SIT (System Integration Testing)
  - UAT (User Acceptance Testing)
  - PROD (Production)

---

## Screenshots

![Example Screenshot](https://github.com/amwal-pay/amwal_pay_sdk/blob/main/screen_shot/example.jpeg?raw=true)
![View Screenshot](https://github.com/amwal-pay/amwal_pay_sdk/blob/main/screen_shot/view.jpeg?raw=true)

---

## Installation

Add the Amwal Pay SDK to your `pubspec.yaml` file:

```yaml
dependencies:
  amwal_pay_sdk:
    git:
      url: https://github.com/amwal-pay/amwal_pay_sdk
      ref: main
```

Then, run `flutter pub get` to install the package.

---

## Usage

### 1. Import the Package

Import the package in your Dart file:

```dart
import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
```

### 2. Fetch the Customer ID and Session Token

To initialize the payment process, you need to fetch the `customerId` and then retrieve the session token from your backend. Here's how you can do it:

```dart
final customerId = await _getCustomerId(); // Fetch the customer ID

final sessionToken = await getSDKSessionToken( // Fetch the session token from the backend
  merchantId: _merchantId,
  customerId: customerId,
);

if (sessionToken == null) return;
```

### 3. Initialize the SDK

Use the `AmwalPaySdk.instance.initSdk` method to initialize the SDK with the required settings:

```dart
await AmwalPaySdk.instance.initSdk(
  settings: AmwalSdkSettings(
    environment: Environment.UAT, // Specify the environment (SIT, UAT, or PROD)
    sessionToken: sessionToken ?? '', // Session token from backend
    currency: 'OMR', // Currency (e.g., OMR)
    amount: '100', // Amount (e.g., 100)
    transactionId: const Uuid().v1(), // Unique transaction ID
    merchantId: 'YOUR_MERCHANT_ID', // Your merchant ID
    terminalId: 'YOUR_TERMINAL_ID', // Your terminal ID
    locale: Locale('en'), // Locale for the payment (e.g., "en")
    isMocked: false, // Disable mocked data
    isNfc: (_transactionTypeController.text == 'NFC' ? true : false), // Enable NFC if needed
    customerCallback: _onCustomerId, // Callback for customer ID
    customerId: customerId, // The customer ID for this transaction
    onResponse: _onResponse, // Callback for the payment response
  ),
);
```

---

## Example

You can find a complete example of how to use the Amwal Pay SDK in the [Example Directory](https://github.com/amwal-pay/amwal_pay_sdk/-/tree/master/example).

---

## Parameters

### `AmwalSdkSettings` Parameters

| Parameter         | Description                                             |
| ----------------- |---------------------------------------------------------|
| `environment`     | The environment for the SDK (`Environment.SIT`, `Environment.UAT`, or `Environment.PROD`) |
| `sessionToken`    | The session token obtained from your backend            |
| `currency`        | Name of the currency that the client will pay with      |
| `amount`          | The amount of payment                                   |
| `transactionId`   | Unique identifier for the transaction                   |
| `merchantId`      | Your Merchant Id                                        |
| `terminalId`      | Your terminalId                                         |
| `locale`          | The locale for the payment process (e.g., "en" or "ar") |
| `isMocked`        | Whether to use mocked data (for testing)                |
| `isNfc`           | Whether NFC is enabled for the transaction              |
| `customerCallback`| The callback function for customer id after finish      |
| `customerId`      | The customer ID for this transaction                    |
| `onResponse`      | The callback function to handle the payment response    |

---

## Callbacks

### `customerCallback`

This callback is triggered after the payment process is completed. It provides the `customerId` as a parameter:

```dart
void _onCustomerId(String customerId) {
  print('Customer ID: $customerId');
}
```

### `onResponse`

This callback is triggered when the payment response is received. It provides the payment response as a parameter:

```dart
void _onResponse(dynamic response) {
  print('Payment Response: $response');
}
```

---

## Environment Configuration

The `environment` parameter allows you to specify the environment for the SDK:

- **`Environment.SIT`**: System Integration Testing
- **`Environment.UAT`**: User Acceptance Testing
- **`Environment.PROD`**: Production

Example:

```dart
environment: Environment.UAT, // Use UAT for testing
```

---

## Issues

If you encounter any issues while using the SDK, please file a bug report in the [Github Issue Tracker](https://github.com/amwal-pay/amwal_pay_sdk/-/issues).

---

## Contributing

We welcome contributions! Please read the [Contributing Guidelines](https://github.com/amwal-pay/amwal_pay_sdk/-/blob/master/CHANGELOG.md) before submitting a pull request.

---

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/amwal-pay/amwal_pay_sdk/-/blob/master/LICENSE) file for details.

---

**Free Software, Hell Yeah!** 🎉
```

