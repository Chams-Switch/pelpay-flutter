import 'dart:async';

import 'package:flutter/services.dart';

import 'models/pelpay_result.dart';
import 'models/transaction.dart';

class PelpayFlutter {
  static const MethodChannel _channel = MethodChannel('pelpay_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  //set transaction
  static Future<PelpayResult> makePayment({
    required String clientId,
    required String clientSecret,
    required Transaction transaction,
    required bool isProduction,
    String brandPrimaryColorInHex = "#009F49",
    bool shouldHidePelpaySecureLogo = false,
  }) async {
    try {
      final Map<String, dynamic> params = <String, dynamic>{
        "clientId": clientId,
        "clientSecret": clientSecret,
        "transaction": transaction.toMap(),
        "isProduction": isProduction,
        "brandPrimaryColorInHex": brandPrimaryColorInHex,
        "shouldHidePelpaySecureLogo": shouldHidePelpaySecureLogo
      };

      final String result = await _channel.invokeMethod('makePayment', params);
      var _adviceReference = result;
      return PelpayResult(
          isTransactionSuccessful: true,
          adviceReference: _adviceReference,
          errorMessage: null);
    } on PlatformException catch (e) {
      var _errorMessage = "${e.message}";
      return PelpayResult(
          isTransactionSuccessful: false,
          adviceReference: null,
          errorMessage: _errorMessage);
    }
  }
}
