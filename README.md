# Amwal Pay Sdk

Amwal Pay SDK built in flutter makes online payment easier.

## Features
- Payment With Wallet
    - with mobile number
    - with alias name
    - with QRCode
- Payment With Card

## Requirements
- Put the sdk navigator observer in the navigatorObservers in the material app

```sh
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amwal pay Demo',
      navigatorObservers: [
        AmwalSdkNavigator.amwalNavigatorObserver,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DemoScreen(),
    );
  }
}
```

## Usage
-  Add the package as a dependency in your 'pubspec.yaml' file:
```sh
dependencies:
  amwal_pay_sdk: ^0.0.1
```
-  Import the package in your dart file where you want to use it by adding the following line at the top of the file:

```sh
import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
```
-  To route to the Amwal Pay Screen:
```sh

            final settings = AmwalSdkSettings(
                      token: "your_token",
                      currency: "EGP",
                      amount: "240",
                      merchantId: "1593578",
                      secureHashValue: "F458998E564E454E545F",
                      terminalId: "15874953",
                      isMocked: true,
                      is3DS: true,
                    );

            await AmwalPaySdk.instance.initSdk(
                    settings: settings
                  );
```


## Example
You can see a full example of how to use the package in the [Example] example directory.

## Issues
If you encounter any issues while using the package, please file a bug report in [the GitLab issue tracker].


## Contributing

If you would like to contribute to the package, please read the [Contributing Guidelines] before submitting a pull request.


## AmwalSdkSettings Parameters
| Parameters | Name |
| ------ | ------ |
| token | your token to use this package|
| currency | Name of the currency that client will pay with |
| amount  | The amount of payment|
| merchantId | Your Merchant Id goes here|
| terminalId | terminalId goes here|
| isMocked | true if you want to try this package use case and false if you want to use real apis |







**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   

