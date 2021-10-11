# Pelpay Flutter SDK

[![pub package](https://img.shields.io/pub/v/pelpay_flutter.svg)](https://pub.dev/packages/pelpay_flutter)


Welcome to Pelpay's Flutter SDK. This library will help you accept card and alternative payments in your iOS & Android apps.
**The Pelpay Flutter SDK permits a deployment target of Android version 21 or higher & iOS version 9.0 and higher**.


## Features
- Highly customizable: Change look & feel of the SDK to suit your brand, set your own logo
- Multiple payment methods
- 3D-Secure & many more

| Pay VIA Credit Card | Pay VIA Bank Payment | Pay VIA Bank Transfer |
| ------------- | ------------- | ------------- |
| <img src="https://raw.githubusercontent.com/Chams-Switch/pelpay-ios/main/images/pelpay_card_payment.gif"  />  | <img src="https://raw.githubusercontent.com/Chams-Switch/pelpay-ios/main/images/pelpay_bank_payment.gif"  />  |<img src="https://raw.githubusercontent.com/Chams-Switch/pelpay-ios/main/images/pelpay_bank_transfer.gif"  />|



## Installation
1. Add the Pelpay package to the dependencies section of your `pubspec.yaml` file. The code below makes the Dart API of the `pelpay_flutter` plugin available in your application

   ```yaml
   dependencies:
    pelpay_flutter: ^1.0.0
   ```

2. Run the following command in your terminal after navigating to your project directory, to download the package

    ```shell
    flutter pub get
    ```

## Using the Pelpay SDK

**Step 1**: Import the Pelpay sdk files

```dart
import 'package:pelpay_flutter/models/customer.dart';
import 'package:pelpay_flutter/models/transaction.dart';
import 'package:pelpay_flutter/pelpay_flutter.dart';

```

**Step 2**: Complete integration with `makePayment` method. Provide your own values, where needed

```dart
     try {
      var result = await PelpayFlutter.makePayment(
          clientId: "CLIENT_ID_FROM_MERCHANT_DASHBOARD",
          clientSecret: "CLIENT_SECRET_FROM_MERCHANT_DASHBOARD",
          transaction: Transaction(
            integrationKey: "INTEGRATION_KEY_FROM_MERCHANT_DASHBOARD",
            amount: 50,
            merchantReference: UniqueKey().toString(),
            narration: "Sample payment from Flutter",
            customer: Customer(
                    customerId: "xxx",
                    customerLastName: "olajuwon",
                    customerFirstName: "adeoye",
                    customerEmail: "olajuwon@yopmail.com",
                    customerPhoneNumber: "07039544295",
                    customerAddress: "Lekki 1, Road",
                    customerCity: "Lagos",
                    customerStateCode: "LA",
                    customerPostalCode: "123456")
                .toMap(),
          ),
          isProduction: false);

      if (result.isTransactionSuccessful) {
        // ignore: avoid_print
        print("Successful, Your Advice Reference: ${result.adviceReference}");
      } else {
        // ignore: avoid_print
        print(result.errorMessage);
      }
    } on PlatformException catch (e) {
      var error = "Pelpay Error: '${e.message}'.";
      // ignore: avoid_print
      print(error);
    }
```

**Note** : Ensure when going live, you change the implementation from Staging `isProduction : false` to production `isProduction: true`. 
Also ensure you don't use staging credentials on production

**Demo**

Use the `5061 2000 0000 0000 195` test card number to trigger an OTP payment flow with CVV/CVC: `109` future expiration date: `12/2025`, Pin: `1234`

Use the `4456 5300 0000 0007` test card number to trigger a 3D Secure payment flow with CVV/CVC: `444` future expiration date: `12/2025`, Pin: `1234`

Use the *WEMA BANK* with Account number `0238681912` to test bank transactions.

OTP: `123456`


---


## Configuration (Android)

**Note** : There are extra conditions required for the SDK to work on Android 

---

**Step 1**: Go to the manifest of your android project within your Flutter project, and add `tools:replace="android:label"` to the `<application>` e.g

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">
   <application
        tools:replace="android:label">
```

**Step 2**: Go to the styles file of the android app within your flutter project, and ensure the app theme inherits from `Theme.MaterialComponents` e.g

```xml
    <style name="NormalTheme" parent="Theme.MaterialComponents.Light.DarkActionBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>

```

**If you have any issues, check the example app within the the Pelpay SDK **

## Example

To run the example project, clone the repo, and run the following command in your terminal:
```shell
flutter run
```

## License

Pelpay SDK is available under the MIT license. See the LICENSE file for more info.
